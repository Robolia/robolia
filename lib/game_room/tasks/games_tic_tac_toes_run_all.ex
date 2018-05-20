defmodule GameRoom.Tasks.GamesTicTacToesRunAll do
  @moduledoc """
  This is the trigger for running all the Tic Tac Toe games
  for all the active players.

  This task is meant to be running by a scheduler.
  """

  alias GameRoom.Games.TicTacToes.RunMatchesPipeline
  alias GameRoom.Games.{Game, Queries}
  alias GameRoom.Repo

  def run do
    start_app()

    tictactoe = Game |> Queries.for_game(%{slug: "tic-tac-toe"}) |> Repo.one!()

    RunMatchesPipeline.call(%{game: tictactoe})
  end

  defp start_app do
    Application.load(:game_room)
    Application.ensure_all_started(:postgrex)
    Application.ensure_all_started(:ecto)

    Repo.start_link()
  end
end
