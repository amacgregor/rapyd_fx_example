defmodule RapydFxExample.Repo.Migrations.CreateWallets do
  use Ecto.Migration

  def change do
    create table(:wallets) do
      add :name, :string
      add :ewallet_id, :string
      add :url, :string

      timestamps()
    end
  end
end
