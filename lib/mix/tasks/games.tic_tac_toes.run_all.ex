defmodule Mix.Tasks.Games.TicTacToes.RunAll do
  use Mix.Task

  @shortdoc "Run Tic Tac Toes games for all active players"

  @moduledoc """
  This is the trigger for running all the Tic Tac Toe games
  for all the active players.

  This task is meant to be running by a scheduler.
  """

  alias GameRoom.Games.TicTacToes.RunMatchesPipeline
  alias GameRoom.Games.{Game, Queries}
  alias GameRoom.Repo
  import Mix.Ecto

  def run(_args) do
    Mix.shell().info("Running all Tic Tac Toe games.")
    ensure_started(GameRoom.Repo, [])

    tictactoe = Game |> Queries.for_game(%{slug: "tic-tac-toe"}) |> Repo.one!()

    RunMatchesPipeline.call(%{game: tictactoe})
    Mix.shell().info("Done.")
  end
end
