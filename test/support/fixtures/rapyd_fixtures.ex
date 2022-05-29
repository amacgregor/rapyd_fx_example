defmodule RapydFxExample.RapydFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RapydFxExample.Rapyd` context.
  """

  @doc """
  Generate a wallet.
  """
  def wallet_fixture(attrs \\ %{}) do
    {:ok, wallet} =
      attrs
      |> Enum.into(%{
        ewallet_id: "some ewallet_id",
        name: "some name",
        url: "some url"
      })
      |> RapydFxExample.Rapyd.create_wallet()

    wallet
  end

  @doc """
  Generate a beneficiary.
  """
  def beneficiary_fixture(attrs \\ %{}) do
    {:ok, beneficiary} =
      attrs
      |> Enum.into(%{
        currency: "some currency",
        first_name: "some first_name",
        last_name: "some last_name",
        uuid: "some uuid"
      })
      |> RapydFxExample.Rapyd.create_beneficiary()

    beneficiary
  end
end
