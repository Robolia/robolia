defmodule Robolia.Games.RunMatches do
  use Opus.Pipeline

  alias Phoenix.PubSub
  alias Robolia.{Rating, Repo}
  alias Robolia.Accounts.Player
  alias Robolia.Accounts.Queries, as: AccountQueries

  check :valid_params?,
    with:
      &match?(
        %{
          competition: _,
          competition_opts: _,
          emulator: _,
          game: _,
          game_aggregator: _
        },
        &1
      )

  step(:fetch_players)
  step(:generate_matches)
  step(:run_matches)

  def fetch_players(%{game: game} = data) do
    players =
      Player
      |> AccountQueries.for_game(%{game_id: game.id})
      |> AccountQueries.active()
      |> Repo.all()

    put_in(data, [:players], players)
  end

  def generate_matches(
        %{players: players, competition: competition, competition_opts: competition_opts} = data
      ) do
    matches =
      %{players: players}
      |> Map.merge(competition_opts)
      |> competition.generate_matches()

    put_in(data, [:matches], matches)
  end

  def run_matches(
        %{
          game: game,
          matches: matches,
          emulator: emulator,
          game_aggregator: game_aggregator,
          emulator_config: emulator_config
        } = data
      ) do
    for players_of_match <- matches do
      {:ok, match} =
        emulator.run_match(%{
          players: players_of_match,
          game: game,
          game_aggregator: game_aggregator,
          config: emulator_config
        })

      match = game_aggregator.update_match!(match, %{finished_at: current_datetime()})
      Rating.update_players_rating(match)
      PubSub.broadcast(Robolia.PubSub, "match_finished", %{match: match, event: "match_finished"})
    end

    data
  end

  defp current_datetime do
    NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
  end
end
