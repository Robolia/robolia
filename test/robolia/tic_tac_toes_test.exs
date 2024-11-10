defmodule Robolia.Games.TicTacToesTest do
  use Robolia.DataCase
  alias Robolia.Games.TicTacToes
  alias Robolia.Games.TicTacToes.TicTacToeMoviment
  alias Robolia.GameError

  setup do
    p1 = insert(:player)
    p2 = insert(:player)
    game = insert(:game)

    match =
      insert(
        :tic_tac_toe_match,
        first_player_id: p1.id,
        second_player_id: p2.id,
        next_player_id: p1.id,
        game_id: game.id
      )

    {:ok, %{p1: p1, p2: p2, game: game, match: match}}
  end

  describe "create_match!/1" do
    test "creates a match when giving :first_player_id and :second_player_id", ctx do
      expected = %{
        first_player_id: ctx.p1.id,
        second_player_id: ctx.p2.id,
        next_player_id: ctx.p1.id,
        winner_id: nil
      }

      result =
        TicTacToes.create_match!(%{
          first_player_id: ctx.p1.id,
          second_player_id: ctx.p2.id,
          next_player_id: ctx.p1.id,
          game_id: ctx.game.id
        })
        |> Map.take([:first_player_id, :second_player_id, :next_player_id, :winner_id])

      assert result == expected
    end

    test "raises a GameError exception when not giving :first_player_id", ctx do
      assert_raise GameError, fn ->
        TicTacToes.create_match!(%{second_player_id: ctx.p2.id})
      end
    end

    test "raises a GameError exception when not giving :second_player_id", ctx do
      assert_raise GameError, fn ->
        TicTacToes.create_match!(%{first_player_id: ctx.p1.id})
      end
    end
  end

  describe "add_moviment!/2" do
    test "creates a moviment when giving an existent TicTacToeMatch and a valid position and player_id",
         ctx do
      position = 1

      expected = %{
        position: position,
        tic_tac_toe_match_id: ctx.match.id,
        player_id: ctx.p1.id
      }

      result =
        ctx.match
        |> TicTacToes.add_moviment!(%{position: position, player_id: ctx.p1.id, turn: 1})
        |> Map.take([:position, :tic_tac_toe_match_id, :player_id])

      assert result == expected
    end

    test "creates a moviment when given a position between 1 and 9", ctx do
      1..9
      |> Enum.each(fn position ->
        result =
          ctx.match
          |> TicTacToes.add_moviment!(%{
            position: position,
            player_id: ctx.p2.id,
            turn: position
          })

        assert %TicTacToeMoviment{} = result
      end)
    end

    test "updates match.next_player to p2 if current next player is p1", ctx do
      ctx.match |> TicTacToes.add_moviment!(%{position: 1, player_id: ctx.p1.id, turn: 1})

      assert TicTacToes.refresh(ctx.match).next_player_id == ctx.p2.id
    end

    test "updates match.next_player to p1 if current next player is p2", ctx do
      ctx.match |> TicTacToes.add_moviment!(%{position: 1, player_id: ctx.p1.id, turn: 1})

      TicTacToes.refresh(ctx.match)
      |> TicTacToes.add_moviment!(%{position: 2, player_id: ctx.p2.id, turn: 2})

      assert TicTacToes.refresh(ctx.match).next_player_id == ctx.p1.id
    end

    test "updates match.next_player to nil if it was the last possible moviment", ctx do
      ctx.match |> TicTacToes.add_moviment!(%{position: 1, player_id: ctx.p1.id, turn: 1})
      ctx.match |> TicTacToes.add_moviment!(%{position: 2, player_id: ctx.p2.id, turn: 2})
      ctx.match |> TicTacToes.add_moviment!(%{position: 3, player_id: ctx.p1.id, turn: 3})
      ctx.match |> TicTacToes.add_moviment!(%{position: 4, player_id: ctx.p2.id, turn: 4})
      ctx.match |> TicTacToes.add_moviment!(%{position: 5, player_id: ctx.p1.id, turn: 5})
      ctx.match |> TicTacToes.add_moviment!(%{position: 6, player_id: ctx.p2.id, turn: 6})
      ctx.match |> TicTacToes.add_moviment!(%{position: 7, player_id: ctx.p1.id, turn: 7})
      ctx.match |> TicTacToes.add_moviment!(%{position: 8, player_id: ctx.p2.id, turn: 8})
      ctx.match |> TicTacToes.add_moviment!(%{position: 9, player_id: ctx.p1.id, turn: 9})

      assert TicTacToes.refresh(ctx.match).next_player_id == nil
    end

    test "raises a GameError exception when given a non-existent TicTacToe", ctx do
      assert_raise GameError, fn ->
        build(:tic_tac_toe_match, id: 999)
        |> TicTacToes.add_moviment!(%{position: 1, player_id: ctx.p1.id, turn: 1})
      end
    end

    test "raises a GameError exception when given a position already filled by the same player",
         ctx do
      position = 1

      ctx.match
      |> TicTacToes.add_moviment!(%{position: position, player_id: ctx.p1.id, turn: 1})

      assert_raise GameError, fn ->
        ctx.match
        |> TicTacToes.add_moviment!(%{position: position, player_id: ctx.p1.id, turn: 2})
      end
    end

    test "raises a GameError exception when given a position already filled by the other player",
         ctx do
      position = 1

      ctx.match
      |> TicTacToes.add_moviment!(%{position: position, player_id: ctx.p1.id, turn: 1})

      assert_raise GameError, fn ->
        ctx.match
        |> TicTacToes.add_moviment!(%{
          position: position,
          player_id: ctx.p2.id,
          turn: 2
        })
      end
    end
  end

  describe "current_state/1" do
    test "returns a map with the current state of the given match", %{match: match} do
      insert(
        :tic_tac_toe_moviment,
        position: 1,
        tic_tac_toe_match_id: match.id,
        player_id: match.first_player_id,
        turn: 1
      )

      insert(
        :tic_tac_toe_moviment,
        position: 5,
        tic_tac_toe_match_id: match.id,
        player_id: match.second_player_id,
        turn: 2
      )

      insert(
        :tic_tac_toe_moviment,
        position: 9,
        tic_tac_toe_match_id: match.id,
        player_id: match.first_player_id,
        turn: 3
      )

      result = TicTacToes.current_state(match)

      assert result == %{
               p1: :x,
               p2: nil,
               p3: nil,
               p4: nil,
               p5: :o,
               p6: nil,
               p7: nil,
               p8: nil,
               p9: :x
             }
    end
  end
end
