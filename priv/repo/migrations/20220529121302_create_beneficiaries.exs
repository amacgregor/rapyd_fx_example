defmodule RapydFxExample.Repo.Migrations.CreateBeneficiaries do
  use Ecto.Migration

  def change do
    create table(:beneficiaries) do
      add :first_name, :string
      add :last_name, :string
      add :currency, :string
      add :uuid, :string

      timestamps()
    end
  end
end
