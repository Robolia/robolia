defmodule GameRoomWeb.LayoutView do
  use GameRoomWeb, :view

  def maybe_active_navbar_item(%{request_path: request_path}, item_path) do
    if request_path == item_path do
      "active"
    else
      ""
    end
  end
end
