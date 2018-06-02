defmodule RoboliaWeb.MatchesView do
  use RoboliaWeb, :view
  import RoboliaWeb.TicTacToesView, only: [status_label: 1]
  import RoboliaWeb.LayoutView, only: [maybe_active_navbar_item: 2]
  import RoboliaWeb.Helpers.PlayerHelper
  import RoboliaWeb.Helpers.UserHelper

  def format_match_date(nil), do: "-"

  def format_match_date(date) do
    "#{date.day}/#{date.month}/#{date.year} #{date.hour}:#{date.minute}:#{date.second}"
  end
end
