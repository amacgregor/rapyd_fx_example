defmodule RapydFxExampleWeb.PayoutController do
  use RapydFxExampleWeb, :controller

  alias RapydFxExample.Rapyd
  alias RapydFxExample.Rapyd.Payout

  def index(conn, _params) do
    payouts = Rapyd.list_payouts()
    render(conn, "index.html", payouts: payouts)
  end

  def new(conn, _params) do
    changeset = Rapyd.change_payout(%Payout{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"payout" => payout_params}) do

    # Define the base url and target path
    base_url = "https://sandboxapi.rapyd.net"
    url_path = "/v1/payouts"

    # Generate the values needed for the headers
    access_key = Application.fetch_env!(:rapyd_fx_example, :rapyd_access_key)
    salt = :crypto.strong_rand_bytes(8) |> Base.encode64() |> binary_part(0, 8)
    timestamp = System.os_time(:second)

    # Generate request body
    body = create_payout_request(payout_params)

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

    IO.inspect(response)

    # Replace the Wallet params for id and url
    payout_params = payout_params
      |> Map.put("payout_transaction", response["data"]["id"])

    case Rapyd.create_payout(payout_params) do
      {:ok, payout} ->
        conn
        |> put_flash(:info, "Payout created successfully.")
        |> redirect(to: Routes.payout_path(conn, :show, payout))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def confirm(conn, %{"id" => id}) do
    payout = Rapyd.get_payout!(id)
    # Define the base url and target path
    base_url = "https://sandboxapi.rapyd.net"
    url_path = "/v1/payouts/confirm/" <> payout.payout_transaction

    # Generate the values needed for the headers
    access_key = Application.fetch_env!(:rapyd_fx_example, :rapyd_access_key)
    salt = :crypto.strong_rand_bytes(8) |> Base.encode64() |> binary_part(0, 8)
    timestamp = System.os_time(:second)

    # Generate request body
    body = ""

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

    conn
    |> put_flash(:info, "Payout confirmed successfully.")
    |> redirect(to: Routes.payout_path(conn, :index, []))
  end

  def complete(conn, %{"id" => id}) do
    payout = Rapyd.get_payout!(id)
    IO.inspect(payout)
    # Define the base url and target path
    base_url = "https://sandboxapi.rapyd.net"
    url_path = "/v1/payouts/complete/" <> payout.payout_transaction <> "/" <> to_string(payout.payout_amount * 100)

    # Generate the values needed for the headers
    access_key = Application.fetch_env!(:rapyd_fx_example, :rapyd_access_key)
    salt = :crypto.strong_rand_bytes(8) |> Base.encode64() |> binary_part(0, 8)
    timestamp = System.os_time(:second)

    # Generate request body
    body = ""

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

    conn
    |> put_flash(:info, "Payout completed successfully.")
    |> redirect(to: Routes.payout_path(conn, :index, []))
  end

  def check(conn, _params) do
    # Define the base url and target path
    base_url = "https://sandboxapi.rapyd.net"
    url_path = "/v1/payouts/ca_general_bank/details?beneficiary_country=ca&beneficiary_entity_type=individual&payout_amount=15&payout_currency=usd&sender_country=us&sender_currency=usd&sender_entity_type=company"

    # Generate the values needed for the headers
    access_key = Application.fetch_env!(:rapyd_fx_example, :rapyd_access_key)
    salt = :crypto.strong_rand_bytes(8) |> Base.encode64() |> binary_part(0, 8)
    timestamp = System.os_time(:second)

    # Generate request body
    body = ""

    signature = sign_request("get", url_path, salt, timestamp, access_key, to_string(body))

    # Build the headers
    headers = [
      {"access_key", access_key},
      {"salt", salt},
      {"timestamp", timestamp},
      {"url_path", url_path},
      {"signature", signature}
    ]

    response = HTTPoison.get!(base_url <> url_path, headers)
    response = response.body |> Jason.decode!()

      IO.inspect(response)

      # render(conn, "index.html", response: response)
  end

  def retrieve(conn, _params) do
    # Define the base url and target path
    base_url = "https://sandboxapi.rapyd.net"
    url_path = "/v1/payouts/payout_762b363a6778c506cb8904cab4560885"

    # Generate the values needed for the headers
    access_key = Application.fetch_env!(:rapyd_fx_example, :rapyd_access_key)
    salt = :crypto.strong_rand_bytes(8) |> Base.encode64() |> binary_part(0, 8)
    timestamp = System.os_time(:second)

    # Generate request body
    body = ""

    signature = sign_request("get", url_path, salt, timestamp, access_key, to_string(body))

    # Build the headers
    headers = [
      {"access_key", access_key},
      {"salt", salt},
      {"timestamp", timestamp},
      {"url_path", url_path},
      {"signature", signature}
    ]

    response = HTTPoison.get!(base_url <> url_path, headers)
    response = response.body |> Jason.decode!()

    conn
    |> put_flash(:info, "Payout updated successfully.")
    |> redirect(to: Routes.payout_path(conn, :index, []))

  end

  def show(conn, %{"id" => id}) do
    payout = Rapyd.get_payout!(id)
    render(conn, "show.html", payout: payout)
  end

  def edit(conn, %{"id" => id}) do
    payout = Rapyd.get_payout!(id)
    changeset = Rapyd.change_payout(payout)
    render(conn, "edit.html", payout: payout, changeset: changeset)
  end

  def update(conn, %{"id" => id, "payout" => payout_params}) do
    payout = Rapyd.get_payout!(id)

    case Rapyd.update_payout(payout, payout_params) do
      {:ok, payout} ->
        conn
        |> put_flash(:info, "Payout updated successfully.")
        |> redirect(to: Routes.payout_path(conn, :show, payout))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", payout: payout, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    payout = Rapyd.get_payout!(id)
    {:ok, _payout} = Rapyd.delete_payout(payout)

    conn
    |> put_flash(:info, "Payout deleted successfully.")
    |> redirect(to: Routes.payout_path(conn, :index))
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

  defp create_payout_request(params) do
    {:ok, body} =
      %{
        beneficiary: params["beneficiary"],
        ewallet: params["ewallet_id"],
        beneficiary_entity_type: params["beneficiary_entity_type"],
        confirm_automatically: false,
        description: "FX with confirmation",
        payout_amount: params["payout_amount"],
        payout_method_type: "ca_general_bank",
        payout_currency: params["payout_currency"],
        sender: %{
          country: "US",
          city: "Austin",
          address: "123 Rodeo Drive",
          state: "Texas",
          postcode: "73220",
          name: "Bob Smith",
          currency: "USD",
          entity_type: "company",
          identification_value: "123456789",
          identification_type: "incorporation_number"
        },
        sender_country: "US",
        sender_currency: "USD",
        sender_entity_type: "company",
      }
      |> Jason.encode()

      body
  end
end
