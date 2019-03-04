defmodule Boards.TicTacToeBoardTest do
  use ExUnit.Case
  alias TicTacToeBoard, as: Subject

  describe "valid_position?/2" do
    setup do
      board = %{
        p1: :x,
        p2: nil,
        p3: nil,
        p4: nil,
        p5: :o,
        p6: nil,
        p7: nil,
        p8: nil,
        p9: nil
      }

      {:ok, board: board}
    end

    test "returns {:ok, true} when position is between 1 and 9 and it's not filled on the board",
         %{board: board} do
      assert Subject.valid_position?(board, 2) == {:ok, true}
    end

    test "returns {:error, :position_value_not_allowed} when position is not between 1 and 9", %{
      board: board
    } do
      assert Subject.valid_position?(board, 10) == {:error, :position_value_not_allowed}
    end

    test "returns {:error, :position_value_not_allowed} when position is not an integer", %{
      board: board
    } do
      assert Subject.valid_position?(board, "2") == {:error, :position_value_not_allowed}
    end

    test "returns {:error, :position_value_not_allowed} when position is already filled", %{
      board: board
    } do
      assert Subject.valid_position?(board, 5) == {:error, :filled_position}
    end
  end

  describe "match_finished?/1" do
    test "returns true when all positions are filled" do
      board = %{
        p1: :o,
        p2: :x,
        p3: :o,
        p4: :x,
        p5: :o,
        p6: :x,
        p7: :x,
        p8: :o,
        p9: :x
      }

      assert Subject.match_finished?(board) == true
    end

    test "returns true when first player won" do
      board = %{
        p1: :x,
        p2: :x,
        p3: :x,
        p4: nil,
        p5: :o,
        p6: :o,
        p7: nil,
        p8: nil,
        p9: nil
      }

      assert Subject.match_finished?(board) == true
    end

    test "returns true when second player won" do
      board = %{
        p1: :x,
        p2: :x,
        p3: nil,
        p4: :o,
        p5: :o,
        p6: :o,
        p7: nil,
        p8: nil,
        p9: :x
      }

      assert Subject.match_finished?(board) == true
    end

    test "returns false when not all position are filled and no winner is found" do
      board = %{
        p1: :x,
        p2: :x,
        p3: nil,
        p4: nil,
        p5: :o,
        p6: :o,
        p7: nil,
        p8: nil,
        p9: :x
      }

      assert Subject.match_finished?(board) == false
    end
  end

  describe "positions_filled/1" do
    test "returns the number of filled positions" do
      board = %{
        p1: :x,
        p2: :x,
        p3: nil,
        p4: nil,
        p5: :o,
        p6: :o,
        p7: nil,
        p8: nil,
        p9: :x
      }

      assert Subject.positions_filled(board) == 5
    end
  end

  describe "next_turn/1" do
    test "returns positions filled + 1 if positions filled < 9" do
      board = %{
        p1: :x,
        p2: :x,
        p3: :x,
        p4: nil,
        p5: :o,
        p6: :o,
        p7: nil,
        p8: nil,
        p9: nil
      }

      assert Subject.next_turn(board) == 6
    end

    test "returns nil if positions filled >= 9" do
      board = %{
        p1: :o,
        p2: :x,
        p3: :o,
        p4: :x,
        p5: :o,
        p6: :x,
        p7: :x,
        p8: :o,
        p9: :x
      }

      assert Subject.next_turn(board) == nil
    end
  end

  describe "fetch_winner/1" do
    test "returns :x if the first player won" do
      board = %{
        p1: :x,
        p2: :x,
        p3: :x,
        p4: nil,
        p5: :o,
        p6: :o,
        p7: nil,
        p8: nil,
        p9: nil
      }

      assert Subject.fetch_winner(board) == :x
    end

    test "returns :o if the second player won" do
      board = %{
        p1: :x,
        p2: :x,
        p3: nil,
        p4: :o,
        p5: :o,
        p6: :o,
        p7: nil,
        p8: nil,
        p9: :x
      }

      assert Subject.fetch_winner(board) == :o
    end

    test "returns nil if no winner is found" do
      board = %{
        p1: :x,
        p2: :x,
        p3: nil,
        p4: nil,
        p5: :o,
        p6: :o,
        p7: nil,
        p8: nil,
        p9: :x
      }

      assert Subject.fetch_winner(board) == nil
    end
  end

  describe "fetch_next_player/3" do
    test "returns first player when next moviment is :x" do
      board = %{
        p1: :x,
        p2: :x,
        p3: nil,
        p4: nil,
        p5: :o,
        p6: :o,
        p7: nil,
        p8: nil,
        p9: nil
      }

      assert Subject.fetch_next_player(board, :p1, :p2) == :p1
    end

    test "returns second player when next moviment is :0" do
      board = %{
        p1: :x,
        p2: :x,
        p3: nil,
        p4: nil,
        p5: :o,
        p6: :o,
        p7: nil,
        p8: nil,
        p9: :x
      }

      assert Subject.fetch_next_player(board, :p1, :p2) == :p2
    end

    test "returns nil when all positions are filled" do
      board = %{
        p1: :o,
        p2: :x,
        p3: :o,
        p4: :x,
        p5: :o,
        p6: :x,
        p7: :x,
        p8: :o,
        p9: :x
      }

      assert Subject.fetch_next_player(board, :p1, :p2) == nil
    end

    test "returns nil when there is a winner on the board" do
      board = %{
        p1: :x,
        p2: :x,
        p3: nil,
        p4: :o,
        p5: :o,
        p6: :o,
        p7: nil,
        p8: nil,
        p9: :x
      }

      assert Subject.fetch_next_player(board, :p1, :p2) == nil
    end
  end

  describe "fetch_winner/3" do
    test "returns the given first player if it has won" do
      board = %{
        p1: :x,
        p2: :x,
        p3: :x,
        p4: nil,
        p5: :o,
        p6: :o,
        p7: nil,
        p8: nil,
        p9: nil
      }

      assert Subject.fetch_winner(board, :p1, :p2) == :p1
    end

    test "returns the given second player if it has won" do
      board = %{
        p1: :x,
        p2: :x,
        p3: nil,
        p4: :o,
        p5: :o,
        p6: :o,
        p7: nil,
        p8: nil,
        p9: :x
      }

      assert Subject.fetch_winner(board, :p1, :p2) == :p2
    end

    test "returns nil if no winner is found" do
      board = %{
        p1: :x,
        p2: :x,
        p3: nil,
        p4: nil,
        p5: :o,
        p6: :o,
        p7: nil,
        p8: nil,
        p9: :x
      }

      assert Subject.fetch_winner(board, :p1, :p2) == nil
    end
  end
end
