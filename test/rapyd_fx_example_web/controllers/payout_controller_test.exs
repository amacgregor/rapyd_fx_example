defmodule RapydFxExampleWeb.PayoutControllerTest do
  use RapydFxExampleWeb.ConnCase

  import RapydFxExample.RapydFixtures

  @create_attrs %{beneficiary: "some beneficiary", beneficiary_entity_type: "some beneficiary_entity_type", ewallet_id: "some ewallet_id", payout_amount: 120.5, payout_currency: "some payout_currency", payout_transaction: "some payout_transaction"}
  @update_attrs %{beneficiary: "some updated beneficiary", beneficiary_entity_type: "some updated beneficiary_entity_type", ewallet_id: "some updated ewallet_id", payout_amount: 456.7, payout_currency: "some updated payout_currency", payout_transaction: "some updated payout_transaction"}
  @invalid_attrs %{beneficiary: nil, beneficiary_entity_type: nil, ewallet_id: nil, payout_amount: nil, payout_currency: nil, payout_transaction: nil}

  describe "index" do
    test "lists all payouts", %{conn: conn} do
      conn = get(conn, Routes.payout_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Payouts"
    end
  end

  describe "new payout" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.payout_path(conn, :new))
      assert html_response(conn, 200) =~ "New Payout"
    end
  end

  describe "create payout" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.payout_path(conn, :create), payout: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.payout_path(conn, :show, id)

      conn = get(conn, Routes.payout_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Payout"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.payout_path(conn, :create), payout: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Payout"
    end
  end

  describe "edit payout" do
    setup [:create_payout]

    test "renders form for editing chosen payout", %{conn: conn, payout: payout} do
      conn = get(conn, Routes.payout_path(conn, :edit, payout))
      assert html_response(conn, 200) =~ "Edit Payout"
    end
  end

  describe "update payout" do
    setup [:create_payout]

    test "redirects when data is valid", %{conn: conn, payout: payout} do
      conn = put(conn, Routes.payout_path(conn, :update, payout), payout: @update_attrs)
      assert redirected_to(conn) == Routes.payout_path(conn, :show, payout)

      conn = get(conn, Routes.payout_path(conn, :show, payout))
      assert html_response(conn, 200) =~ "some updated beneficiary"
    end

    test "renders errors when data is invalid", %{conn: conn, payout: payout} do
      conn = put(conn, Routes.payout_path(conn, :update, payout), payout: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Payout"
    end
  end

  describe "delete payout" do
    setup [:create_payout]

    test "deletes chosen payout", %{conn: conn, payout: payout} do
      conn = delete(conn, Routes.payout_path(conn, :delete, payout))
      assert redirected_to(conn) == Routes.payout_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.payout_path(conn, :show, payout))
      end
    end
  end

  defp create_payout(_) do
    payout = payout_fixture()
    %{payout: payout}
  end
end
