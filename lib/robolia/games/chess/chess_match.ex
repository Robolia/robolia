defmodule Robolia.Games.Chess.ChessMatch do
  use Ecto.Schema
  import Ecto.Changeset
  alias Robolia.Accounts.Player
  alias Robolia.Games.Game
  alias Robolia.Games.Chess.ChessMoviment
  alias __MODULE__

  # @statuses {:ongoing, :draw, :winner}

  schema "chess_matches" do
    field(:status, :integer)
    field(:finished_at, :naive_datetime)

    belongs_to(:first_player, Player, foreign_key: :first_player_id)
    belongs_to(:second_player, Player, foreign_key: :second_player_id)
    belongs_to(:next_player, Player, foreign_key: :next_player_id)
    belongs_to(:winner, Player, foreign_key: :winner_id)
    belongs_to(:game, Game, foreign_key: :game_id)
    has_many(:moviments, ChessMoviment)

    timestamps()
  end

  def ongoing, do: 0
  def draw, do: 1
  def winner, do: 2

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(%ChessMatch{} = chess, params \\ %{}) do
    chess
    |> cast(params, [
      :first_player_id,
      :second_player_id,
      :next_player_id,
      :game_id,
      :status,
      :finished_at
    ])
    |> validate_required([:first_player_id, :second_player_id, :next_player_id, :game_id])
  end
end
