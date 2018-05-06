defmodule GameRoomWeb.TicTacToesView do
  use GameRoomWeb, :view
  import GameRoomWeb.Helpers.UserHelper

  def map_by_position(moviments), do: moviments |> Map.new(&({&1.position, &1}))
end
