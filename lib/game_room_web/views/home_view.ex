defmodule GameRoomWeb.HomeView do
  use GameRoomWeb, :view
  import GameRoomWeb.TicTacToesView, only: [status_label: 1]

  def format_match_date(nil), do: "-"

  def format_match_date(date) do
    "#{date.day}/#{date.month}/#{date.year} #{date.hour}:#{date.minute}:#{date.second}"
  end
end
