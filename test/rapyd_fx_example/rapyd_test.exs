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
end
