defmodule RapydFxExampleWeb.BeneficiaryController do
  use RapydFxExampleWeb, :controller

  alias RapydFxExample.Rapyd
  alias RapydFxExample.Rapyd.Beneficiary

  def index(conn, _params) do
    beneficiaries = Rapyd.list_beneficiaries()
    render(conn, "index.html", beneficiaries: beneficiaries)
  end

  def new(conn, _params) do
    changeset = Rapyd.change_beneficiary(%Beneficiary{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"beneficiary" => beneficiary_params}) do
    # Define the base url and target path
    base_url = "https://sandboxapi.rapyd.net"
    url_path = "/v1/payouts/beneficiary"

    # Generate the values needed for the headers
    access_key = Application.fetch_env!(:rapyd_fx_example, :rapyd_access_key)
    salt = :crypto.strong_rand_bytes(8) |> Base.encode64() |> binary_part(0, 8)
    timestamp = System.os_time(:second)

    # Generate request body
    body = create_beneficiary_request(beneficiary_params)

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
    beneficiary_params = beneficiary_params
      |> Map.put("uuid", response["data"]["id"])

    case Rapyd.create_beneficiary(beneficiary_params) do
      {:ok, beneficiary} ->
        conn
        |> put_flash(:info, "Beneficiary created successfully.")
        |> redirect(to: Routes.beneficiary_path(conn, :show, beneficiary))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    beneficiary = Rapyd.get_beneficiary!(id)
    render(conn, "show.html", beneficiary: beneficiary)
  end

  def edit(conn, %{"id" => id}) do
    beneficiary = Rapyd.get_beneficiary!(id)
    changeset = Rapyd.change_beneficiary(beneficiary)
    render(conn, "edit.html", beneficiary: beneficiary, changeset: changeset)
  end

  def update(conn, %{"id" => id, "beneficiary" => beneficiary_params}) do
    beneficiary = Rapyd.get_beneficiary!(id)

    case Rapyd.update_beneficiary(beneficiary, beneficiary_params) do
      {:ok, beneficiary} ->
        conn
        |> put_flash(:info, "Beneficiary updated successfully.")
        |> redirect(to: Routes.beneficiary_path(conn, :show, beneficiary))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", beneficiary: beneficiary, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    beneficiary = Rapyd.get_beneficiary!(id)
    {:ok, _beneficiary} = Rapyd.delete_beneficiary(beneficiary)

    conn
    |> put_flash(:info, "Beneficiary deleted successfully.")
    |> redirect(to: Routes.beneficiary_path(conn, :index))
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

  defp create_beneficiary_request(params) do
    {:ok, body} =
      %{
        first_name: params["first_name"],
        last_name: params["last_name"],
        country: "CA",
        currency: params["currency"],
        category: "bank",
        entity_type: "individual"
      }
      |> Jason.encode()

      body
  end
end
