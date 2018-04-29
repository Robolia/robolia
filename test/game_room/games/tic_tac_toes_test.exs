defmodule GameRoom.Games.TicTacToesTest do
  use GameRoom.DataCase
  alias GameRoom.Games.TicTacToes
  alias GameRoom.Games.TicTacToes.{TicTacToeMoviment, TicTacToeMatch, Queries}
  alias GameRoom.GameError
  alias GameRoom.Repo

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

    {:ok, %{first_player: first_player, second_player: second_player, game: game, match: match}}
  end

  describe "match_finished?/1" do
    test "returns true when match has 9 moviments and no winner move is found", ctx do
      insert(
        :tic_tac_toe_moviment,
        position: 1,
        tic_tac_toe_match_id: ctx.match.id,
        player_id: ctx.match.first_player_id
      )

      insert(
        :tic_tac_toe_moviment,
        position: 2,
        tic_tac_toe_match_id: ctx.match.id,
        player_id: ctx.match.second_player_id
      )

      insert(
        :tic_tac_toe_moviment,
        position: 3,
        tic_tac_toe_match_id: ctx.match.id,
        player_id: ctx.match.first_player_id
      )

      insert(
        :tic_tac_toe_moviment,
        position: 4,
        tic_tac_toe_match_id: ctx.match.id,
        player_id: ctx.match.second_player_id
      )

      insert(
        :tic_tac_toe_moviment,
        position: 5,
        tic_tac_toe_match_id: ctx.match.id,
        player_id: ctx.match.first_player_id
      )

      insert(
        :tic_tac_toe_moviment,
        position: 7,
        tic_tac_toe_match_id: ctx.match.id,
        player_id: ctx.match.second_player_id
      )

      insert(
        :tic_tac_toe_moviment,
        position: 6,
        tic_tac_toe_match_id: ctx.match.id,
        player_id: ctx.match.first_player_id
      )

      insert(
        :tic_tac_toe_moviment,
        position: 9,
        tic_tac_toe_match_id: ctx.match.id,
        player_id: ctx.match.second_player_id
      )

      insert(
        :tic_tac_toe_moviment,
        position: 8,
        tic_tac_toe_match_id: ctx.match.id,
        player_id: ctx.match.first_player_id
      )

      assert TicTacToes.match_finished?(ctx.match) == {true, %{winner: nil}}
    end

    test "returns true when match has an winner", ctx do
      match =
        insert(
          :tic_tac_toe_match,
          first_player_id: ctx.first_player.id,
          second_player_id: ctx.second_player.id,
          game_id: ctx.game.id,
          winner_id: ctx.second_player.id
        )

      assert TicTacToes.match_finished?(match) == {true, %{winner: ctx.second_player}}
    end

    test "returns true when match has not a registered winner but current state has a winner move",
         ctx do
      insert(
        :tic_tac_toe_moviment,
        position: 1,
        tic_tac_toe_match_id: ctx.match.id,
        player_id: ctx.match.first_player_id
      )

      insert(
        :tic_tac_toe_moviment,
        position: 2,
        tic_tac_toe_match_id: ctx.match.id,
        player_id: ctx.match.first_player_id
      )

      insert(
        :tic_tac_toe_moviment,
        position: 3,
        tic_tac_toe_match_id: ctx.match.id,
        player_id: ctx.match.first_player_id
      )

      assert TicTacToes.match_finished?(ctx.match) == {true, %{winner: ctx.first_player}}
    end

    test "returns false when match has 8 or less moviments and no winner move is found", ctx do
      insert(
        :tic_tac_toe_moviment,
        position: 1,
        tic_tac_toe_match_id: ctx.match.id,
        player_id: ctx.match.first_player_id
      )

      insert(
        :tic_tac_toe_moviment,
        position: 2,
        tic_tac_toe_match_id: ctx.match.id,
        player_id: ctx.match.second_player_id
      )

      insert(
        :tic_tac_toe_moviment,
        position: 3,
        tic_tac_toe_match_id: ctx.match.id,
        player_id: ctx.match.first_player_id
      )

      insert(
        :tic_tac_toe_moviment,
        position: 4,
        tic_tac_toe_match_id: ctx.match.id,
        player_id: ctx.match.second_player_id
      )

      insert(
        :tic_tac_toe_moviment,
        position: 5,
        tic_tac_toe_match_id: ctx.match.id,
        player_id: ctx.match.first_player_id
      )

      insert(
        :tic_tac_toe_moviment,
        position: 7,
        tic_tac_toe_match_id: ctx.match.id,
        player_id: ctx.match.second_player_id
      )

      insert(
        :tic_tac_toe_moviment,
        position: 6,
        tic_tac_toe_match_id: ctx.match.id,
        player_id: ctx.match.first_player_id
      )

      insert(
        :tic_tac_toe_moviment,
        position: 9,
        tic_tac_toe_match_id: ctx.match.id,
        player_id: ctx.match.second_player_id
      )

      assert TicTacToes.match_finished?(ctx.match) == {false, %{winner: nil}}
    end
  end

  describe "create_match!/1" do
    test "creates a match when giving :first_player_id and :second_player_id", ctx do
      expected = %{
        first_player_id: ctx.first_player.id,
        second_player_id: ctx.second_player.id,
        next_player_id: ctx.first_player.id,
        winner_id: nil
      }

      result =
        TicTacToes.create_match!(%{
          first_player_id: ctx.first_player.id,
          second_player_id: ctx.second_player.id,
          next_player_id: ctx.first_player.id,
          game_id: ctx.game.id
        })
        |> Map.take([:first_player_id, :second_player_id, :next_player_id, :winner_id])

      assert result == expected
    end

    test "raises a GameError exception when not giving :first_player_id", ctx do
      assert_raise GameError, fn ->
        TicTacToes.create_match!(%{second_player_id: ctx.second_player.id})
      end
    end

    test "raises a GameError exception when not giving :second_player_id", ctx do
      assert_raise GameError, fn ->
        TicTacToes.create_match!(%{first_player_id: ctx.first_player.id})
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
        player_id: ctx.first_player.id
      }

      result =
        ctx.match
        |> TicTacToes.add_moviment!(%{position: position, player_id: ctx.first_player.id})
        |> Map.take([:position, :tic_tac_toe_match_id, :player_id])

      assert result == expected
    end

    test "creates a moviment when given a position between 1 and 9", ctx do
      1..9
      |> Enum.each(fn position ->
        result =
          ctx.match
          |> TicTacToes.add_moviment!(%{position: position, player_id: ctx.second_player.id})

        assert %TicTacToeMoviment{} = result
      end)
    end

    test "updates match.next_player to the second_player if current next player is the first",
         ctx do
      ctx.match |> TicTacToes.add_moviment!(%{position: 1, player_id: ctx.first_player.id})
      match = TicTacToeMatch |> Queries.for_match(%{id: ctx.match.id}) |> Repo.one!()
      assert match.next_player_id == ctx.second_player.id
    end

    test "updates match.next_player to the first_player if current next player is the second",
         ctx do
      match = ctx.match |> TicTacToes.update_match!(%{next_player_id: ctx.second_player.id})
      match |> TicTacToes.add_moviment!(%{position: 1, player_id: ctx.second_player.id})
      match = TicTacToeMatch |> Queries.for_match(%{id: ctx.match.id}) |> Repo.one!()
      assert match.next_player_id == ctx.first_player.id
    end

    test "updates match.next_player to nil if this was the last possible moviment in the match",
         ctx do
      ctx.match |> TicTacToes.add_moviment!(%{position: 1, player_id: ctx.first_player.id})
      ctx.match |> TicTacToes.add_moviment!(%{position: 2, player_id: ctx.second_player.id})
      ctx.match |> TicTacToes.add_moviment!(%{position: 3, player_id: ctx.first_player.id})
      ctx.match |> TicTacToes.add_moviment!(%{position: 4, player_id: ctx.second_player.id})
      ctx.match |> TicTacToes.add_moviment!(%{position: 5, player_id: ctx.first_player.id})
      ctx.match |> TicTacToes.add_moviment!(%{position: 6, player_id: ctx.second_player.id})
      ctx.match |> TicTacToes.add_moviment!(%{position: 7, player_id: ctx.first_player.id})
      ctx.match |> TicTacToes.add_moviment!(%{position: 8, player_id: ctx.second_player.id})
      ctx.match |> TicTacToes.add_moviment!(%{position: 9, player_id: ctx.first_player.id})
      match = TicTacToeMatch |> Queries.for_match(%{id: ctx.match.id}) |> Repo.one!()
      assert match.next_player_id == nil
    end

    test "raises a GameError exception when given a non-existent TicTacToe", ctx do
      assert_raise GameError, fn ->
        build(:tic_tac_toe_match, id: 999)
        |> TicTacToes.add_moviment!(%{position: 1, player_id: ctx.first_player.id})
      end
    end

    test "raises a GameError exception when given an existent TicTacToeMatch and a player_id which is not playing the given match",
         ctx do
      another_player = insert(:player)

      assert_raise GameError, fn ->
        ctx.match
        |> TicTacToes.add_moviment!(%{position: 1, player_id: another_player.id})
      end
    end

    test "raises a GameError exception when given a position already filled by the same player",
         ctx do
      position = 1

      ctx.match
      |> TicTacToes.add_moviment!(%{position: position, player_id: ctx.first_player.id})

      assert_raise GameError, fn ->
        ctx.match
        |> TicTacToes.add_moviment!(%{position: position, player_id: ctx.first_player.id})
      end
    end

    test "raises a GameError exception when given a position already filled by the other player",
         ctx do
      position = 1

      ctx.match
      |> TicTacToes.add_moviment!(%{position: position, player_id: ctx.first_player.id})

      assert_raise GameError, fn ->
        ctx.match
        |> TicTacToes.add_moviment!(%{position: position, player_id: ctx.second_player.id})
      end
    end

    test "raises a GameError exception when given a position above 9", ctx do
      position = 10

      assert_raise GameError, fn ->
        ctx.match
        |> TicTacToes.add_moviment!(%{position: position, player_id: ctx.second_player.id})
      end
    end

    test "raises a GameError exception when given a position below 1", ctx do
      position = 0

      assert_raise GameError, fn ->
        ctx.match
        |> TicTacToes.add_moviment!(%{position: position, player_id: ctx.second_player.id})
      end
    end
  end

  describe "next_turn/1" do
    test "returns 1 if given match has no moviments", %{match: match} do
      assert TicTacToes.next_turn(match) == 1
    end

    test "returns 2 if given match has 1 moviment", %{match: match} do
      insert(
        :tic_tac_toe_moviment,
        position: 1,
        tic_tac_toe_match_id: match.id,
        player_id: match.first_player_id
      )

      assert TicTacToes.next_turn(match) == 2
    end

    test "returns 3 if given match has 2 moviments", %{match: match} do
      insert(
        :tic_tac_toe_moviment,
        position: 1,
        tic_tac_toe_match_id: match.id,
        player_id: match.first_player_id
      )

      insert(
        :tic_tac_toe_moviment,
        position: 2,
        tic_tac_toe_match_id: match.id,
        player_id: match.second_player_id
      )

      assert TicTacToes.next_turn(match) == 3
    end

    test "returns nil if given match has 9 moviments", %{match: match} do
      insert(
        :tic_tac_toe_moviment,
        position: 1,
        tic_tac_toe_match_id: match.id,
        player_id: match.first_player_id
      )

      insert(
        :tic_tac_toe_moviment,
        position: 2,
        tic_tac_toe_match_id: match.id,
        player_id: match.second_player_id
      )

      insert(
        :tic_tac_toe_moviment,
        position: 3,
        tic_tac_toe_match_id: match.id,
        player_id: match.first_player_id
      )

      insert(
        :tic_tac_toe_moviment,
        position: 4,
        tic_tac_toe_match_id: match.id,
        player_id: match.second_player_id
      )

      insert(
        :tic_tac_toe_moviment,
        position: 5,
        tic_tac_toe_match_id: match.id,
        player_id: match.first_player_id
      )

      insert(
        :tic_tac_toe_moviment,
        position: 6,
        tic_tac_toe_match_id: match.id,
        player_id: match.second_player_id
      )

      insert(
        :tic_tac_toe_moviment,
        position: 7,
        tic_tac_toe_match_id: match.id,
        player_id: match.first_player_id
      )

      insert(
        :tic_tac_toe_moviment,
        position: 8,
        tic_tac_toe_match_id: match.id,
        player_id: match.second_player_id
      )

      insert(
        :tic_tac_toe_moviment,
        position: 9,
        tic_tac_toe_match_id: match.id,
        player_id: match.first_player_id
      )

      assert TicTacToes.next_turn(match) == nil
    end
  end

  describe "current_state/1" do
    test "returns a map with the current state of the given match", %{match: match} do
      insert(
        :tic_tac_toe_moviment,
        position: 1,
        tic_tac_toe_match_id: match.id,
        player_id: match.first_player_id
      )

      insert(
        :tic_tac_toe_moviment,
        position: 5,
        tic_tac_toe_match_id: match.id,
        player_id: match.second_player_id
      )

      insert(
        :tic_tac_toe_moviment,
        position: 9,
        tic_tac_toe_match_id: match.id,
        player_id: match.first_player_id
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
