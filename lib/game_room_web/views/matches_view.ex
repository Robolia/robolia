defmodule GameRoomWeb.MatchesView do
  use GameRoomWeb, :view
  import GameRoomWeb.TicTacToesView, only: [status_label: 1]
  import GameRoomWeb.LayoutView, only: [maybe_active_navbar_item: 2]
  import Enum, only: [at: 2]

  def format_match_date(nil), do: "-"

  def format_match_date(date) do
    "#{date.day}/#{date.month}/#{date.year} #{date.hour}:#{date.minute}:#{date.second}"
  end

  def format_player_name(name) do
    case name |> String.split(" ") do
      names when length(names) > 2 ->
        "#{at(names, 0)} #{at(names, 1)}"

      _ ->
        name
    end
  end
end
