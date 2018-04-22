defmodule GameRoomWeb.PageController do
  use GameRoomWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
