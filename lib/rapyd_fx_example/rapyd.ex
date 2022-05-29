defmodule RapydFxExample.Rapyd do
  @moduledoc """
  The Rapyd context.
  """

  import Ecto.Query, warn: false
  alias RapydFxExample.Repo

  alias RapydFxExample.Rapyd.Wallet

  @doc """
  Returns the list of wallets.

  ## Examples

      iex> list_wallets()
      [%Wallet{}, ...]

  """
  def list_wallets do
    Repo.all(Wallet)
  end

  @doc """
  Gets a single wallet.

  Raises `Ecto.NoResultsError` if the Wallet does not exist.

  ## Examples

      iex> get_wallet!(123)
      %Wallet{}

      iex> get_wallet!(456)
      ** (Ecto.NoResultsError)

  """
  def get_wallet!(id), do: Repo.get!(Wallet, id)

  @doc """
  Creates a wallet.

  ## Examples

      iex> create_wallet(%{field: value})
      {:ok, %Wallet{}}

      iex> create_wallet(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_wallet(attrs \\ %{}) do
    %Wallet{}
    |> Wallet.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a wallet.

  ## Examples

      iex> update_wallet(wallet, %{field: new_value})
      {:ok, %Wallet{}}

      iex> update_wallet(wallet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_wallet(%Wallet{} = wallet, attrs) do
    wallet
    |> Wallet.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a wallet.

  ## Examples

      iex> delete_wallet(wallet)
      {:ok, %Wallet{}}

      iex> delete_wallet(wallet)
      {:error, %Ecto.Changeset{}}

  """
  def delete_wallet(%Wallet{} = wallet) do
    Repo.delete(wallet)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking wallet changes.

  ## Examples

      iex> change_wallet(wallet)
      %Ecto.Changeset{data: %Wallet{}}

  """
  def change_wallet(%Wallet{} = wallet, attrs \\ %{}) do
    Wallet.changeset(wallet, attrs)
  end

  alias RapydFxExample.Rapyd.Beneficiary

  @doc """
  Returns the list of beneficiaries.

  ## Examples

      iex> list_beneficiaries()
      [%Beneficiary{}, ...]

  """
  def list_beneficiaries do
    Repo.all(Beneficiary)
  end

  @doc """
  Gets a single beneficiary.

  Raises `Ecto.NoResultsError` if the Beneficiary does not exist.

  ## Examples

      iex> get_beneficiary!(123)
      %Beneficiary{}

      iex> get_beneficiary!(456)
      ** (Ecto.NoResultsError)

  """
  def get_beneficiary!(id), do: Repo.get!(Beneficiary, id)

  @doc """
  Creates a beneficiary.

  ## Examples

      iex> create_beneficiary(%{field: value})
      {:ok, %Beneficiary{}}

      iex> create_beneficiary(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_beneficiary(attrs \\ %{}) do
    %Beneficiary{}
    |> Beneficiary.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a beneficiary.

  ## Examples

      iex> update_beneficiary(beneficiary, %{field: new_value})
      {:ok, %Beneficiary{}}

      iex> update_beneficiary(beneficiary, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_beneficiary(%Beneficiary{} = beneficiary, attrs) do
    beneficiary
    |> Beneficiary.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a beneficiary.

  ## Examples

      iex> delete_beneficiary(beneficiary)
      {:ok, %Beneficiary{}}

      iex> delete_beneficiary(beneficiary)
      {:error, %Ecto.Changeset{}}

  """
  def delete_beneficiary(%Beneficiary{} = beneficiary) do
    Repo.delete(beneficiary)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking beneficiary changes.

  ## Examples

      iex> change_beneficiary(beneficiary)
      %Ecto.Changeset{data: %Beneficiary{}}

  """
  def change_beneficiary(%Beneficiary{} = beneficiary, attrs \\ %{}) do
    Beneficiary.changeset(beneficiary, attrs)
  end
end
