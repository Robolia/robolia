defmodule GameRoomWeb.HomeView do
  use GameRoomWeb, :view

  def format_match_date(date) do
    "#{date.day}/#{date.month}/#{date.year} #{date.hour}:#{date.minute}:#{date.second}"
  end
end
