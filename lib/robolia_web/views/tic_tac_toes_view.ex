defmodule RoboliaWeb.TicTacToesView do
  use RoboliaWeb, :view
  import RoboliaWeb.Helpers.UserHelper
  import RoboliaWeb.Helpers.PlayerHelper

  def map_by_position(moviments), do: moviments |> Map.new(&{&1.position, &1})

  def status_label(status) do
    case status do
      0 -> "On going"
      1 -> "Draw"
      2 -> "Finished"
      _ -> ""
    end
  end
end
