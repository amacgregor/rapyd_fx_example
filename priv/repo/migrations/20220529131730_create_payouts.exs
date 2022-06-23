defmodule RapydFxExample.Repo.Migrations.CreatePayouts do
  use Ecto.Migration

  def change do
    create table(:payouts) do
      add :beneficiary, :string
      add :beneficiary_entity_type, :string
      add :payout_amount, :float
      add :payout_currency, :string

      timestamps()
    end
  end
end
