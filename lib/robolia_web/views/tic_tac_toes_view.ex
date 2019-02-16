defmodule RoboliaWeb.TicTacToesView do
  use RoboliaWeb, :view
  import RoboliaWeb.Helpers.UserHelper
  import RoboliaWeb.Helpers.PlayerHelper

  def map_by_position(moviments), do: moviments |> Map.new(&{&1.position, &1})
end
