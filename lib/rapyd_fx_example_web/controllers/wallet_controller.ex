defmodule RapydFxExampleWeb.WalletController do
  use RapydFxExampleWeb, :controller

  alias RapydFxExample.Rapyd
  alias RapydFxExample.Rapyd.Wallet

  def index(conn, _params) do
    wallets = Rapyd.list_wallets()
    render(conn, "index.html", wallets: wallets)
  end

  def new(conn, _params) do
    changeset = Rapyd.change_wallet(%Wallet{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"wallet" => wallet_params}) do
    # Define the base url and target path
    base_url = "https://sandboxapi.rapyd.net"
    url_path = "/v1/user"

    # Generate the values needed for the headers
    access_key = Application.fetch_env!(:rapyd_fx_example, :rapyd_access_key)
    salt = :crypto.strong_rand_bytes(8) |> Base.encode64() |> binary_part(0, 8)
    timestamp = System.os_time(:second)

    # Generate request body
    body = create_wallet_request(wallet_params)

    signature = sign_request("post", url_path, salt, timestamp, access_key, to_string(body))

    # Build the headers
    headers = [
      {"access_key", access_key},
      {"salt", salt},
      {"timestamp", timestamp},
      {"url_path", url_path},
      {"signature", signature}
    ]

    response = HTTPoison.post!(base_url <> url_path, body, headers)
    response = response.body |> Jason.decode!()

    # Replace the Wallet params for id and url
    wallet_params = wallet_params
      |> Map.put("ewallet_id", response["data"]["id"])
      |> Map.put("url", response["data"]["contacts"]["url"])

    case Rapyd.create_wallet(wallet_params) do
      {:ok, wallet} ->
        conn
        |> put_flash(:info, "Wallet created successfully.")
        |> redirect(to: Routes.wallet_path(conn, :show, wallet))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    wallet = Rapyd.get_wallet!(id)
    render(conn, "show.html", wallet: wallet)
  end

  def edit(conn, %{"id" => id}) do
    wallet = Rapyd.get_wallet!(id)
    changeset = Rapyd.change_wallet(wallet)
    render(conn, "edit.html", wallet: wallet, changeset: changeset)
  end

  def update(conn, %{"id" => id, "wallet" => wallet_params}) do
    wallet = Rapyd.get_wallet!(id)

    case Rapyd.update_wallet(wallet, wallet_params) do
      {:ok, wallet} ->
        conn
        |> put_flash(:info, "Wallet updated successfully.")
        |> redirect(to: Routes.wallet_path(conn, :show, wallet))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", wallet: wallet, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    wallet = Rapyd.get_wallet!(id)
    {:ok, _wallet} = Rapyd.delete_wallet(wallet)

    conn
    |> put_flash(:info, "Wallet deleted successfully.")
    |> redirect(to: Routes.wallet_path(conn, :index))
  end

  def sign_request(http_method, url_path, salt, timestamp, access_key, body) do
    secret_key = Application.fetch_env!(:rapyd_fx_example, :rapyd_secret_key)

    cond do
      body == "" ->
        body = ""
      true ->
        {:ok, body} = body |> Jason.encode()
    end

    signature_string =
      [http_method, url_path, salt, timestamp, access_key, secret_key, body] |> Enum.join("")

    :crypto.mac(:hmac, :sha256, secret_key, signature_string)
    |> Base.encode16(case: :lower)
    |> Base.encode64()
  end

  defp create_wallet_request(params) do
    {:ok, body} =
      %{
        first_name: "John",
        last_name: "Doe",
        ewallet_reference_id: params["name"],
        type: "person",
        contact: %{
          phone_number: "5551123456789",
          email: "john.doe@fakeemail.com",
          first_name: "John",
          last_name: "Doe",
          contact_type: "personal",
          country: "US",
        },
      }
      |> Jason.encode()

      body
  end
end
