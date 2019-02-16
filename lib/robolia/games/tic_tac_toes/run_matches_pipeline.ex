defmodule Robolia.Games.TicTacToes.RunMatchesPipeline do
  use Opus.Pipeline

  alias Phoenix.PubSub
  alias Robolia.Accounts.Queries, as: AccountQueries
  alias Robolia.Accounts.Player
  alias Robolia.Games.{TicTacToes, Rating}
  alias Robolia.Games.TicTacToes.Match
  alias Robolia.PlayerContainer
  alias Robolia.Competitions.RandomGroupedAllAgainstAll, as: Competition
  alias Robolia.Repo

  @players_per_group 5

  check :valid_params?, with: &match?(%{game: _}, &1)

  step(:assign_players)
  step(:run_matches)

  def assign_players(%{game: game} = data) do
    players =
      Player
      |> AccountQueries.for_game(%{game_id: game.id})
      |> AccountQueries.active()
      |> Repo.all()

    put_in(data, [:players], players)
  end

  def run_matches(%{players: players, game: game}) do
    for {p1, p2} <-
          Competition.generate_matches(%{players: players, per_group: @players_per_group}) do
      PlayerContainer.build(%{game: game, player: p1})
      PlayerContainer.build(%{game: game, player: p2})

      {:ok, match} =
        TicTacToes.create_match!(%{
          first_player_id: p1.id,
          second_player_id: p2.id,
          next_player_id: p1.id,
          game_id: game.id
        })
        |> Repo.preload([:next_player, :game])
        |> Match.play()

      PlayerContainer.delete(%{game: game, player: p1})
      PlayerContainer.delete(%{game: game, player: p2})

      match = TicTacToes.update_match!(match, %{finished_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)})
      Rating.update_players_rating(match)
      PubSub.broadcast(Robolia.PubSub, "match_finished", %{match: match, event: "match_finished"})
    end
  end
end
