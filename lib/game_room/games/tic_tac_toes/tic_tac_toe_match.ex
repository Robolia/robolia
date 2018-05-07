defmodule GameRoom.Games.TicTacToes.TicTacToeMatch do
  use Ecto.Schema
  import Ecto.Changeset
  alias GameRoom.Accounts.Player
  alias GameRoom.Games.Game
  alias GameRoom.Games.TicTacToes.TicTacToeMoviment
  alias __MODULE__

  # @statuses {:ongoing, :draw, :winner}

  schema "tic_tac_toe_matches" do
    field(:status, :integer)
    field(:finished_at, :utc_datetime)

    belongs_to(:first_player, Player, foreign_key: :first_player_id)
    belongs_to(:second_player, Player, foreign_key: :second_player_id)
    belongs_to(:next_player, Player, foreign_key: :next_player_id)
    belongs_to(:winner, Player, foreign_key: :winner_id)
    belongs_to(:game, Game, foreign_key: :game_id)
    has_many(:moviments, TicTacToeMoviment)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(%TicTacToeMatch{} = tic_tak_toe, params \\ %{}) do
    tic_tak_toe
    |> cast(params, [:first_player_id, :second_player_id, :next_player_id, :game_id, :status, :finished_at])
    |> validate_required([:first_player_id, :second_player_id, :next_player_id, :game_id])
  end
end
