defmodule Robolia.Games.TicTacToes.TicTacToeMoviment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Robolia.Games.TicTacToes.TicTacToeMatch
  alias Robolia.Accounts.Player, as: Player

  schema "tic_tac_toe_moviments" do
    field(:position, :integer)
    field(:turn, :integer)
    field(:valid, :boolean)
    field(:details, :string)

    belongs_to(:tic_tac_toe_match, TicTacToeMatch, foreign_key: :tic_tac_toe_match_id)
    belongs_to(:player, Player, foreign_key: :player_id)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:turn, :position, :tic_tac_toe_match_id, :player_id, :valid, :details])
    |> validate_required([:turn, :tic_tac_toe_match_id, :player_id])
  end
end
