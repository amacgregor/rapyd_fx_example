defmodule RapydFxExample.Rapyd.Beneficiary do
  use Ecto.Schema
  import Ecto.Changeset

  schema "beneficiaries" do
    field :currency, :string
    field :first_name, :string
    field :last_name, :string
    field :uuid, :string

    timestamps()
  end

  @doc false
  def changeset(beneficiary, attrs) do
    beneficiary
    |> cast(attrs, [:first_name, :last_name, :currency, :uuid])
    |> validate_required([:first_name, :last_name, :currency, :uuid])
  end
end
