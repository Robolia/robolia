defmodule GameRoom.Games.TicTacToes.TicTacToe do
  use Ecto.Schema
  import Ecto.Changeset
  alias GameRoom.Accounts.User, as: Player
  alias __MODULE__

  schema "tic_tac_toes" do
    belongs_to(:first_player, Player, foreign_key: :first_player_id)
    belongs_to(:second_player, Player, foreign_key: :second_player_id)
    belongs_to(:next_player, Player, foreign_key: :next_player_id)
    belongs_to(:winner, Player, foreign_key: :winner_id)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(%TicTacToe{} = tic_tak_toe, params \\ %{}) do
    tic_tak_toe
    |> cast(params, [:first_player_id, :second_player_id])
    |> validate_required([:first_player_id, :second_player_id])
  end
end
