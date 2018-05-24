defmodule GameRoom.Accounts.PlayerRating do
  use Ecto.Schema
  import Ecto.Changeset
  alias GameRoom.Accounts.Player
  alias GameRoom.Games.Game

  schema "player_ratings" do
    field(:rating, :float)
    belongs_to(:player, Player, foreign_key: :player_id)
    belongs_to(:game, Game, foreign_key: :game_id)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:rating, :player_id, :game_id])
    |> validate_required([:rating, :player_id, :game_id])
  end
end
