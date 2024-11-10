defmodule Robolia.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:name, :string)
    field(:github_id, :integer)
    field(:avatar_url, :string)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :github_id, :avatar_url])
    |> validate_required([:name, :github_id])
    |> unique_constraint(:github_id)
  end
end
