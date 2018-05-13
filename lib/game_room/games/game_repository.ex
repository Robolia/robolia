defmodule GameRoom.Games.GameRepository do
  use Ecto.Schema
  import Ecto.Changeset
  alias GameRoom.Games.Game

  schema "game_repositories" do
    field(:repository_url, :string)
    field(:language, :string)
    field(:image_url, :string)

    belongs_to(:game, Game, foreign_key: :game_id)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:repository_url, :game_id, :image_url, :language])
    |> validate_required([:repository_url, :game_id, :image_url, :language])
  end
end
