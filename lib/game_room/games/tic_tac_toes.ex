defmodule GameRoom.Games.TicTacToes do
  alias GameRoom.Games.TicTacToes.{TicTacToe, TicTacToeMoviment}
  alias GameRoom.{GameError, Repo}

  def create_game!(attrs) do
    %TicTacToe{}
    |> TicTacToe.changeset(attrs)
    |> Repo.insert!()
  rescue
    e in Ecto.InvalidChangesetError -> error(e)
  end

  def add_moviment!(%TicTacToe{id: game_id} = game, %{position: position} = attrs) do
    unless valid_position_number?(position),
      do: raise GameError, message: "Position #{position} is invalid for this game"

    unless game |> player_playing?(attrs),
      do: raise GameError, message: "Given player is not playing this game"

    attrs = attrs |> Map.merge(%{tic_tac_toe_id: game_id})

    %TicTacToeMoviment{}
    |> TicTacToeMoviment.changeset(attrs)
    |> Repo.insert!()
  rescue
    e in Ecto.InvalidChangesetError -> error(e)
    e in Ecto.ConstraintError -> error(e)
  end

  defp player_playing?(game, %{player_id: player_id}) do
    import GameRoom.Games.TicTacToes.Queries,
      only: [for_game: 2, for_player: 2, count: 1]

    TicTacToe
    |> for_game(%{id: game.id})
    |> for_player(%{id: player_id})
    |> count() > 0
  end

  defp valid_position_number?(position_number) do
    position_number >= 1 && position_number <= 9
  end

  defp error(exception) do
    reraise GameError, [exception: exception], System.stacktrace
  end
end
