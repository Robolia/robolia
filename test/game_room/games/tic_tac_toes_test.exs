defmodule GameRoom.Games.TicTacToesTest do
  use GameRoom.DataCase
  alias GameRoom.Games.TicTacToes
  alias GameRoom.GameError

  setup do
    first_player = insert(:user)
    second_player = insert(:user)

    {:ok, %{first_player: first_player, second_player: second_player}}
  end

  describe "create_game!/1" do
    test "when giving :first_player_id and :second_player_id then creates a game", ctx do
      expected = %{
        first_player_id: ctx.first_player.id,
        second_player_id: ctx.second_player.id,
        next_player_id: nil,
        winner_id: nil
      }

      result = TicTacToes.create_game!(%{
        first_player_id: ctx.first_player.id,
        second_player_id: ctx.second_player.id
      })
      |> Map.take([:first_player_id, :second_player_id, :next_player_id, :winner_id])

      assert result == expected
    end

    test "when not giving :first_player_id then raises a GameError exception", ctx do
      assert_raise GameError, fn ->
        TicTacToes.create_game!(%{second_player_id: ctx.second_player.id})
      end
    end

    test "when not giving :second_player_id then raises a GameError exception", ctx do
      assert_raise GameError, fn ->
        TicTacToes.create_game!(%{first_player_id: ctx.first_player.id})
      end
    end
  end

  describe "add_moviment!/2" do
    setup ctx do
      game = insert(:tic_tac_toe, first_player_id: ctx.first_player.id, second_player_id: ctx.second_player.id)
      {:ok, game: game}
    end

    test "when giving an existent TicTacToe and a valid position and player_id then creates a moviment", ctx do
      position = 1
      expected = %{
        position: position,
        tic_tac_toe_id: ctx.game.id,
        player_id: ctx.first_player.id
      }

      result = ctx.game
               |> TicTacToes.add_moviment!(%{position: position, player_id: ctx.first_player.id})
               |> Map.take([:position, :tic_tac_toe_id, :player_id])

      assert result == expected
    end

    test "when given a non-existent TicTacToe then raises a GameError exception", ctx do
      assert_raise GameError, fn ->
        build(:tic_tac_toe, id: 999)
        |> TicTacToes.add_moviment!(%{position: 1, player_id: ctx.first_player.id})
      end
    end
  end
end
