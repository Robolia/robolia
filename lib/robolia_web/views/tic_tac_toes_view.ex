defmodule RoboliaWeb.TicTacToesView do
  use RoboliaWeb, :view

  def map_by_position(moviments), do: Map.new(moviments, &{&1.position, &1})
end
