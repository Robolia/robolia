defmodule RoboliaWeb.AccountHTML do
  @moduledoc """
  This module contains pages rendered by HomeController.

  See the `home_html` directory for all templates available.
  """
  use RoboliaWeb, :html
  import RoboliaWeb.Helpers.PlayerHelper, only: [fetch_rating: 1, current_rank_position: 1]

  embed_templates "account_html/*"

  def format_player_status(active) do
    case active do
      true -> "Active"
      false -> "Inactive"
    end
  end

  def format_player_language(language) do
    language |> String.capitalize()
  end
end
