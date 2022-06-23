defmodule RapydFxExample.Rapyd.Payout do
  use Ecto.Schema
  import Ecto.Changeset

  schema "payouts" do
    field :beneficiary, :string
    field :beneficiary_entity_type, :string
    field :ewallet_id, :string
    field :payout_amount, :float
    field :payout_currency, :string
    field :payout_transaction, :string

    timestamps()
  end

  @doc false
  def changeset(payout, attrs) do
    payout
    |> cast(attrs, [:beneficiary, :beneficiary_entity_type, :payout_amount, :payout_currency, :ewallet_id, :payout_transaction])
    |> validate_required([:beneficiary, :beneficiary_entity_type, :payout_amount, :payout_currency, :ewallet_id, :payout_transaction])
  end
end
