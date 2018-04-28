defmodule GameRoom.Games.TicTacToes.TicTacToeMoviment do
  use Ecto.Schema
  import Ecto.Changeset
  alias GameRoom.Games.TicTacToes.TicTacToeMatch
  alias GameRoom.Accounts.User, as: Player

  schema "tic_tac_toe_moviments" do
    field(:position, :integer)
    belongs_to(:tic_tac_toe_match, TicTacToeMatch, foreign_key: :tic_tac_toe_match_id)
    belongs_to(:player, Player, foreign_key: :player_id)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:position, :tic_tac_toe_match_id, :player_id])
    |> validate_required([:position, :tic_tac_toe_match_id, :player_id])
  end
end
