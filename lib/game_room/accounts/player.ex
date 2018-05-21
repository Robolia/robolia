defmodule GameRoom.Accounts.Player do
  use Ecto.Schema
  import Ecto.Changeset
  alias GameRoom.Accounts.{User, PlayerRating}
  alias GameRoom.Games.Game

  schema "players" do
    field(:repository_url, :string)
    field(:repository_clone_url, :string)
    field(:language, :string)
    field(:active, :boolean)
    belongs_to(:game, Game, foreign_key: :game_id)
    belongs_to(:user, User, foreign_key: :user_id)
    has_one(:rating, {"player_ratings", PlayerRating})

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :repository_url,
      :repository_clone_url,
      :game_id,
      :language,
      :user_id,
      :active
    ])
    |> validate_required([:repository_url, :repository_clone_url, :game_id, :language, :user_id])
  end
end
