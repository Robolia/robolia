defmodule Boards.ChessBoard do
  @moduledoc """
  Board logic for Chess game
  """

  def valid_position?(map, position) do
    {:ok, true}
  end

  def position_available?(map, position) do
    true
  end

  def match_finished?(map) do
    false
  end

  def next_turn(map) do
    2
  end

  def fetch_next_player(map, p1, p2) do
    p1
  end

  def fetch_winner(map), do: nil
end
