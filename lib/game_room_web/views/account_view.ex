defmodule GameRoomWeb.AccountView do
  use GameRoomWeb, :view
  import GameRoomWeb.Helpers.PlayerHelper, only: [fetch_rating: 1, current_rank_position: 1]

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
