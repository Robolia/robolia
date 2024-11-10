defmodule Robolia.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset
  alias Robolia.Games.GameRepository

  schema "games" do
    field(:name, :string)
    field(:slug, :string)
    field(:image_url, :string)

    has_many(:repositories, {"game_repositories", GameRepository})

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :slug, :image_url])
    |> validate_required([:name, :slug, :image_url])
  end
end
