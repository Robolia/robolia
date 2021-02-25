defmodule Robolia.Games.Chess.ChessMoviment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Robolia.Games.Chess.ChessMatch
  alias Robolia.Accounts.Player, as: Player

  schema "chess_movements" do
    field(:position, :string)
    field(:turn, :integer)
    field(:valid, :boolean)
    field(:details, :string)

    belongs_to(:chess_match, ChessMatch, foreign_key: :chess_match_id)
    belongs_to(:player, Player, foreign_key: :player_id)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:turn, :position, :chess_match_id, :player_id, :valid, :details])
    |> validate_required([:turn, :chess_match_id, :player_id])
  end
end
