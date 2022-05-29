defmodule RapydFxExample.Rapyd.Wallet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "wallets" do
    field :ewallet_id, :string
    field :name, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(wallet, attrs) do
    wallet
    |> cast(attrs, [:name, :ewallet_id, :url])
    |> validate_required([:name, :ewallet_id, :url])
  end
end
