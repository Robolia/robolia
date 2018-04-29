defmodule GameRoom.Games.TicTacToes.Match.WinnerTest do
  alias GameRoom.Games.TicTacToes.Match.Winner
  use GameRoom.DataCase

  describe "calculate/1" do
    test "returns player 1 if it has filled the first entire row" do
      match_state = %{
        p1: :x,
        p2: :x,
        p3: :x,
        p4: :o,
        p5: :o,
        p6: nil,
        p7: nil,
        p8: nil,
        p9: nil
      }

      params = %{
        current_state: match_state,
        first_player: build(:player),
        second_player: build(:player)
      }

      assert Winner.calculate(params) == params[:first_player]
    end

    test "returns player 2 if it has filled the first entire row" do
      match_state = %{
        p1: :o,
        p2: :o,
        p3: :o,
        p4: :x,
        p5: nil,
        p6: :x,
        p7: nil,
        p8: :x,
        p9: nil
      }

      params = %{
        current_state: match_state,
        first_player: build(:player),
        second_player: build(:player)
      }

      assert Winner.calculate(params) == params[:second_player]
    end

    test "returns player 1 if it has filled the first entire column" do
      match_state = %{
        p1: :x,
        p2: :o,
        p3: nil,
        p4: :x,
        p5: :o,
        p6: nil,
        p7: :x,
        p8: nil,
        p9: nil
      }

      params = %{
        current_state: match_state,
        first_player: build(:player),
        second_player: build(:player)
      }

      assert Winner.calculate(params) == params[:first_player]
    end

    test "returns player 2 if it has filled the second entire column" do
      match_state = %{
        p1: :x,
        p2: :o,
        p3: nil,
        p4: :x,
        p5: :o,
        p6: nil,
        p7: nil,
        p8: :o,
        p9: :x
      }

      params = %{
        current_state: match_state,
        first_player: build(:player),
        second_player: build(:player)
      }

      assert Winner.calculate(params) == params[:second_player]
    end

    test "returns player 1 if it has filled the one of the diagonals" do
      match_state = %{
        p1: :x,
        p2: :o,
        p3: nil,
        p4: :x,
        p5: :x,
        p6: nil,
        p7: :o,
        p8: :o,
        p9: :x
      }

      params = %{
        current_state: match_state,
        first_player: build(:player),
        second_player: build(:player)
      }

      assert Winner.calculate(params) == params[:first_player]
    end

    test "returns player 2 if it has filled the one of the diagonals" do
      match_state = %{
        p1: :x,
        p2: :x,
        p3: :o,
        p4: :x,
        p5: :o,
        p6: nil,
        p7: :o,
        p8: nil,
        p9: nil
      }

      params = %{
        current_state: match_state,
        first_player: build(:player),
        second_player: build(:player)
      }

      assert Winner.calculate(params) == params[:second_player]
    end
  end
end
