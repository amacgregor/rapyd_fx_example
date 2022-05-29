defmodule RapydFxExample.RapydTest do
  use RapydFxExample.DataCase

  alias RapydFxExample.Rapyd

  describe "wallets" do
    alias RapydFxExample.Rapyd.Wallet

    import RapydFxExample.RapydFixtures

    @invalid_attrs %{ewallet_id: nil, name: nil, url: nil}

    test "list_wallets/0 returns all wallets" do
      wallet = wallet_fixture()
      assert Rapyd.list_wallets() == [wallet]
    end

    test "get_wallet!/1 returns the wallet with given id" do
      wallet = wallet_fixture()
      assert Rapyd.get_wallet!(wallet.id) == wallet
    end

    test "create_wallet/1 with valid data creates a wallet" do
      valid_attrs = %{ewallet_id: "some ewallet_id", name: "some name", url: "some url"}

      assert {:ok, %Wallet{} = wallet} = Rapyd.create_wallet(valid_attrs)
      assert wallet.ewallet_id == "some ewallet_id"
      assert wallet.name == "some name"
      assert wallet.url == "some url"
    end

    test "create_wallet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rapyd.create_wallet(@invalid_attrs)
    end

    test "update_wallet/2 with valid data updates the wallet" do
      wallet = wallet_fixture()
      update_attrs = %{ewallet_id: "some updated ewallet_id", name: "some updated name", url: "some updated url"}

      assert {:ok, %Wallet{} = wallet} = Rapyd.update_wallet(wallet, update_attrs)
      assert wallet.ewallet_id == "some updated ewallet_id"
      assert wallet.name == "some updated name"
      assert wallet.url == "some updated url"
    end

    test "update_wallet/2 with invalid data returns error changeset" do
      wallet = wallet_fixture()
      assert {:error, %Ecto.Changeset{}} = Rapyd.update_wallet(wallet, @invalid_attrs)
      assert wallet == Rapyd.get_wallet!(wallet.id)
    end

    test "delete_wallet/1 deletes the wallet" do
      wallet = wallet_fixture()
      assert {:ok, %Wallet{}} = Rapyd.delete_wallet(wallet)
      assert_raise Ecto.NoResultsError, fn -> Rapyd.get_wallet!(wallet.id) end
    end

    test "change_wallet/1 returns a wallet changeset" do
      wallet = wallet_fixture()
      assert %Ecto.Changeset{} = Rapyd.change_wallet(wallet)
    end
  end

  describe "beneficiaries" do
    alias RapydFxExample.Rapyd.Beneficiary

    import RapydFxExample.RapydFixtures

    @invalid_attrs %{currency: nil, first_name: nil, last_name: nil, uuid: nil}

    test "list_beneficiaries/0 returns all beneficiaries" do
      beneficiary = beneficiary_fixture()
      assert Rapyd.list_beneficiaries() == [beneficiary]
    end

    test "get_beneficiary!/1 returns the beneficiary with given id" do
      beneficiary = beneficiary_fixture()
      assert Rapyd.get_beneficiary!(beneficiary.id) == beneficiary
    end

    test "create_beneficiary/1 with valid data creates a beneficiary" do
      valid_attrs = %{currency: "some currency", first_name: "some first_name", last_name: "some last_name", uuid: "some uuid"}

      assert {:ok, %Beneficiary{} = beneficiary} = Rapyd.create_beneficiary(valid_attrs)
      assert beneficiary.currency == "some currency"
      assert beneficiary.first_name == "some first_name"
      assert beneficiary.last_name == "some last_name"
      assert beneficiary.uuid == "some uuid"
    end

    test "create_beneficiary/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rapyd.create_beneficiary(@invalid_attrs)
    end

    test "update_beneficiary/2 with valid data updates the beneficiary" do
      beneficiary = beneficiary_fixture()
      update_attrs = %{currency: "some updated currency", first_name: "some updated first_name", last_name: "some updated last_name", uuid: "some updated uuid"}

      assert {:ok, %Beneficiary{} = beneficiary} = Rapyd.update_beneficiary(beneficiary, update_attrs)
      assert beneficiary.currency == "some updated currency"
      assert beneficiary.first_name == "some updated first_name"
      assert beneficiary.last_name == "some updated last_name"
      assert beneficiary.uuid == "some updated uuid"
    end

    test "update_beneficiary/2 with invalid data returns error changeset" do
      beneficiary = beneficiary_fixture()
      assert {:error, %Ecto.Changeset{}} = Rapyd.update_beneficiary(beneficiary, @invalid_attrs)
      assert beneficiary == Rapyd.get_beneficiary!(beneficiary.id)
    end

    test "delete_beneficiary/1 deletes the beneficiary" do
      beneficiary = beneficiary_fixture()
      assert {:ok, %Beneficiary{}} = Rapyd.delete_beneficiary(beneficiary)
      assert_raise Ecto.NoResultsError, fn -> Rapyd.get_beneficiary!(beneficiary.id) end
    end

    test "change_beneficiary/1 returns a beneficiary changeset" do
      beneficiary = beneficiary_fixture()
      assert %Ecto.Changeset{} = Rapyd.change_beneficiary(beneficiary)
    end
  end
end
