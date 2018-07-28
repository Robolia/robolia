defmodule Robolia.Tasks.TicTacToesRegularCompetition do
  @moduledoc """
  This is the trigger for running all the Tic Tac Toe games
  for all the active players.

  This task is meant to be running by a scheduler.
  """

  alias Robolia.Games.TicTacToes.RunMatchesPipeline
  alias Robolia.Games.{Game, Queries}
  alias Robolia.{Repo, Metrics}

  def run do
    tictactoe = Game |> Queries.for_game(%{slug: "tic-tac-toe"}) |> Repo.one!()
    RunMatchesPipeline.call(%{game: tictactoe})
    Metrics.increment("competitions.tic_tac_toes.regular")
  end
end
