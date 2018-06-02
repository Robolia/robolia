defmodule RoboliaWeb.Games.TicTacToeView do
  use RoboliaWeb, :view

  def fetch_mark(nil), do: ""

  def fetch_mark(moviment) do
    case moviment.turn |> rem(2) do
      1 -> "x"
      0 -> "o"
    end
  end
end
