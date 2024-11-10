defmodule RoboliaWeb.MatchesHTML do
  @moduledoc """
  This module contains pages rendered by MatchesController.

  See the `matches_html` directory for all templates available.
  """
  use RoboliaWeb, :html
  import Enum, only: [at: 2]
  alias Robolia.Accounts

  embed_templates "matches_html/*"

  def fetch_rating(player),
    do: player.rating.rating |> :erlang.float_to_binary([:compact, decimals: 2])

  def current_rank_position(player), do: player |> Accounts.current_rank() |> get_in([:position])

  def user_name(user) do
    names = user.name |> String.split(" ")

    case names |> length do
      names_count when names_count > 2 ->
        "#{at(names, 0)} #{at(names, 1)}"

      _ ->
        user.name
    end
  end

  def format_match_date(nil), do: "-"

  def format_match_date(date) do
    "#{date.day}/#{date.month}/#{date.year} #{date.hour}:#{date.minute}:#{date.second}"
  end
end
