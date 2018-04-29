defmodule GameRoom.Games.TicTacToes.MatchTest do
  use GameRoom.DataCase
  alias GameRoom.Games.TicTacToes.Match
  alias GameRoom.Repo
  import Mox

  setup :verify_on_exit!

  describe "play/1" do
    setup do
      first_player = insert(:player)
      second_player = insert(:player)
      game = insert(:game)

      match =
        insert(
          :tic_tac_toe_match,
          first_player_id: first_player.id,
          second_player_id: second_player.id,
          next_player_id: first_player.id,
          game_id: game.id
        )
        |> Repo.preload([:next_player, :game])

      {:ok,
       %{
         match: match,
         first_player_id: first_player.id,
         second_player_id: second_player.id,
         game_id: game.id
       }}
    end

    test "returns a finished {:ok, match} when a winner move is found in the game", ctx do
      GameRoom.PlayerScriptMock |> stub(:run, fn %{next_turn: turn} -> '#{turn}\n' end)
      {:ok, match} = Match.play(ctx.match)
      match = match |> Repo.preload(:moviments)

      match_expected = %{
        id: match.id,
        first_player_id: ctx.first_player_id,
        second_player_id: ctx.second_player_id,
        next_player_id: nil,
        game_id: ctx.game_id
      }

      expected_moviments = [
        %{position: 1, tic_tac_toe_match_id: match.id, player_id: ctx.first_player_id},
        %{position: 2, tic_tac_toe_match_id: match.id, player_id: ctx.second_player_id},
        %{position: 3, tic_tac_toe_match_id: match.id, player_id: ctx.first_player_id},
        %{position: 4, tic_tac_toe_match_id: match.id, player_id: ctx.second_player_id},
        %{position: 5, tic_tac_toe_match_id: match.id, player_id: ctx.first_player_id},
        %{position: 6, tic_tac_toe_match_id: match.id, player_id: ctx.second_player_id},
        %{position: 7, tic_tac_toe_match_id: match.id, player_id: ctx.first_player_id}
      ]

      result =
        Map.take(match, [:id, :first_player_id, :second_player_id, :next_player_id, :game_id])

      result_moviments =
        for m <- match.moviments, do: Map.take(m, [:position, :tic_tac_toe_match_id, :player_id])

      assert result == match_expected
      assert result_moviments == expected_moviments
    end
  end
end
