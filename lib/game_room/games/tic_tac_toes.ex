defmodule GameRoom.Games.TicTacToes do
  alias GameRoom.Games.TicTacToes.{TicTacToe, TicTacToeMoviment}
  alias GameRoom.Repo

  def create_game!(attrs) do
    %TicTacToe{}
    |> TicTacToe.changeset(attrs)
    |> Repo.insert!()
  rescue
    e -> error(e)
  end

  def add_moviment!(%TicTacToe{id: game_id} = _game, attrs) do
    attrs = attrs |> Map.merge(%{tic_tac_toe_id: game_id})

    %TicTacToeMoviment{}
    |> TicTacToeMoviment.changeset(attrs)
    |> Repo.insert!()
  rescue
    e -> error(e)
  end

  defp error(exception) do
    reraise GameRoom.GameError, [exception: exception], System.stacktrace
  end
end
