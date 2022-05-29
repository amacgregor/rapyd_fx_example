defmodule RapydFxExampleWeb.BeneficiaryControllerTest do
  use RapydFxExampleWeb.ConnCase

  import RapydFxExample.RapydFixtures

  @create_attrs %{currency: "some currency", first_name: "some first_name", last_name: "some last_name", uuid: "some uuid"}
  @update_attrs %{currency: "some updated currency", first_name: "some updated first_name", last_name: "some updated last_name", uuid: "some updated uuid"}
  @invalid_attrs %{currency: nil, first_name: nil, last_name: nil, uuid: nil}

  describe "index" do
    test "lists all beneficiaries", %{conn: conn} do
      conn = get(conn, Routes.beneficiary_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Beneficiaries"
    end
  end

  describe "new beneficiary" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.beneficiary_path(conn, :new))
      assert html_response(conn, 200) =~ "New Beneficiary"
    end
  end

  describe "create beneficiary" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.beneficiary_path(conn, :create), beneficiary: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.beneficiary_path(conn, :show, id)

      conn = get(conn, Routes.beneficiary_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Beneficiary"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.beneficiary_path(conn, :create), beneficiary: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Beneficiary"
    end
  end

  describe "edit beneficiary" do
    setup [:create_beneficiary]

    test "renders form for editing chosen beneficiary", %{conn: conn, beneficiary: beneficiary} do
      conn = get(conn, Routes.beneficiary_path(conn, :edit, beneficiary))
      assert html_response(conn, 200) =~ "Edit Beneficiary"
    end
  end

  describe "update beneficiary" do
    setup [:create_beneficiary]

    test "redirects when data is valid", %{conn: conn, beneficiary: beneficiary} do
      conn = put(conn, Routes.beneficiary_path(conn, :update, beneficiary), beneficiary: @update_attrs)
      assert redirected_to(conn) == Routes.beneficiary_path(conn, :show, beneficiary)

      conn = get(conn, Routes.beneficiary_path(conn, :show, beneficiary))
      assert html_response(conn, 200) =~ "some updated currency"
    end

    test "renders errors when data is invalid", %{conn: conn, beneficiary: beneficiary} do
      conn = put(conn, Routes.beneficiary_path(conn, :update, beneficiary), beneficiary: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Beneficiary"
    end
  end

  describe "delete beneficiary" do
    setup [:create_beneficiary]

    test "deletes chosen beneficiary", %{conn: conn, beneficiary: beneficiary} do
      conn = delete(conn, Routes.beneficiary_path(conn, :delete, beneficiary))
      assert redirected_to(conn) == Routes.beneficiary_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.beneficiary_path(conn, :show, beneficiary))
      end
    end
  end

  defp create_beneficiary(_) do
    beneficiary = beneficiary_fixture()
    %{beneficiary: beneficiary}
  end
end
