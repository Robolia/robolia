defmodule Robolia.Tasks.Calibrations.TicTacToes do
  @moduledoc """
  This is the trigger for running all the Tic Tac Toe games
  for all the active players.

  This task is meant to be running by a scheduler.
  """

  require Logger
  use GenServer
  use Confex, otp_app: :robolia

  alias Robolia.Games.TicTacToes.RunMatchesPipeline
  alias Robolia.Games.{Game, Queries}
  alias Robolia.{Repo, Metrics}

  @one_hour 1 * 60 * 60 * 1000

  def start_link(name \\ __MODULE__, state \\ []) do
    GenServer.start_link(name, state)
  end

  @impl true
  def init(state) do
    Logger.info("[#{__MODULE__}] Initalizing")
    send(self(), :run)
    {:ok, state}
  end

  @impl true
  def handle_info(:run, state) do
    if Time.utc_now() |> scheduling_hour?() do
      run()
    end

    schedule_task()
    {:noreply, state}
  end

  defp run do
    Logger.info("[#{__MODULE__}] Running")
    tictactoe = Game |> Queries.for_game(%{slug: "tic-tac-toe"}) |> Repo.one!()
    RunMatchesPipeline.call(%{game: tictactoe})
    Metrics.increment("competitions.tic_tac_toes.regular")
  end

  defp scheduling_hour?(current_time) do
    current_time.hour == scheduling_hour()
  end

  defp schedule_task do
    Logger.info("[#{__MODULE__}] Scheduling")
    Process.send_after(self(), :run, @one_hour)
  end

  defp scheduling_hour, do: config()[:scheduling_hour]
end
