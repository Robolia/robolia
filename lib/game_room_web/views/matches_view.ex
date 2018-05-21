defmodule GameRoomWeb.MatchesView do
  use GameRoomWeb, :view
  import GameRoomWeb.TicTacToesView, only: [status_label: 1]
  import GameRoomWeb.LayoutView, only: [maybe_active_navbar_item: 2]
  import GameRoomWeb.Helpers.PlayerHelper
  import GameRoomWeb.Helpers.UserHelper
  import Enum, only: [at: 2]

  def format_match_date(nil), do: "-"

  def format_match_date(date) do
    "#{date.day}/#{date.month}/#{date.year} #{date.hour}:#{date.minute}:#{date.second}"
  end
end
