defmodule GameRoom.Games.TicTacToes.RunMatchesPipeline do
  use Opus.Pipeline

  alias GameRoom.Accounts.Queries, as: AccountQueries
  alias GameRoom.Accounts.Player
  alias GameRoom.Games.{TicTacToes, Rating}
  alias GameRoom.Games.TicTacToes.{Competition, Match}
  alias GameRoom.PlayerScript
  alias GameRoom.Repo

  @players_per_group 5

  check :valid_params?, with: &match?(%{game: _}, &1)

  step(:assign_players)
  step(:assign_groups)
  step(:run_matches)

  def assign_players(%{game: game} = data) do
    players =
      Player
      |> AccountQueries.for_game(%{game_id: game.id})
      |> AccountQueries.active()
      |> Repo.all()

    put_in(data, [:players], players)
  end

  def assign_groups(%{players: players} = data) do
    groups = Competition.generate_groups(%{players: players, per_group: @players_per_group})
    put_in(data, [:groups], groups)
  end

  def run_matches(%{groups: groups, game: game}) do
    groups
    |> Enum.each(fn group ->
      Competition.distribute_players(group)
      |> Enum.each(fn match_players ->
        run_match(%{match_players: match_players, game: game})
        |> Rating.update_players_rating()
      end)
    end)
  end

  def run_match(%{match_players: {p1, p2}, game: game}) do
    PlayerScript.build(%{game: game, player: p1})
    PlayerScript.build(%{game: game, player: p2})

    {:ok, match} =
      TicTacToes.create_match!(%{
        first_player_id: p1.id,
        second_player_id: p2.id,
        next_player_id: p1.id,
        game_id: game.id
      })
      |> Repo.preload([:next_player, :game])
      |> Match.play()

    PlayerScript.delete(%{game: game, player: p1})
    PlayerScript.delete(%{game: game, player: p2})

    match
  end
end
