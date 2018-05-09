defmodule GameRoomWeb.AccountView do
  use GameRoomWeb, :view

  def format_player_status(active) do
    case active do
      true -> "Active"
      false -> "Not active"
    end
  end

  def format_player_language(language) do
    language |> String.capitalize()
  end
end
