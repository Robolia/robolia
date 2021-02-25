defmodule Robolia.Tasks.Calibrations.Chess do
  @moduledoc """
  This is the trigger for running all the Chess games
  for all the active players.

  This task is meant to be running by a scheduler.
  """

  require Logger
  use GenServer
  use Confex, otp_app: :robolia

  alias Robolia.Commands.RunMatches
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
    if scheduling_hour?(Time.utc_now()) do
      run()
    end

    schedule_task()
    {:noreply, state}
  end

  @impl true
  def handle_call(:run, _from, state) do
    Logger.info("[#{__MODULE__}] Running calibration for Chess in background...")
    run()

    {:noreply, state}
  end

  defp run do
    Logger.info("[#{__MODULE__}] Running")

    chess = Game |> Queries.for_game(%{slug: "chess"}) |> Repo.one!()

    {:ok, _} =
      RunMatches.call(%{
        competition: Competitions.RandomGroupedAllAgainstAll,
        competition_opts: %{per_group: 5},
        emulator: Robolia.Emulators.BoardGamesEmulator,
        emulator_config: %{
          board: Boards.ChessBoard,
          bot_runner_adapter: Robolia.Games.Chess.BotRunnerAdapter
        },
        game: chess,
        game_aggregator: Robolia.Games.Chess
      })

    Metrics.increment("competitions.chess.regular")
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
