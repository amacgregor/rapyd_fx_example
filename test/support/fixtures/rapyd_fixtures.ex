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
end
