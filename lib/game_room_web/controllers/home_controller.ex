defmodule GameRoomWeb.HomeController do
  use GameRoomWeb, :controller

  def index(conn, _params), do: conn |> redirect(to: matches_path(conn, :index))
end
