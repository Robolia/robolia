defmodule GameRoom.Tasks.GamesTicTacToesRunAll do
  @moduledoc """
  This is the trigger for running all the Tic Tac Toe games
  for all the active players.

  This task is meant to be running by a scheduler.
  """

  alias GameRoom.Games.TicTacToes.RunMatchesPipeline
  alias GameRoom.Games.{Game, Queries}
  alias GameRoom.Repo
  require Logger

  def run do
    Logger.info("Running all Tic Tac Toe games.")
    start_app()

    tictactoe = Game |> Queries.for_game(%{slug: "tic-tac-toe"}) |> Repo.one!()

    RunMatchesPipeline.call(%{game: tictactoe})

    Logger.info("Done.")
  end

  defp start_app do
    Application.load(:game_room)
    Application.ensure_all_started(:postgrex)
    Application.ensure_all_started(:ecto)

    Repo.start_link()
  end
end
