defmodule GameRoomWeb.Plugs.Authentication do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _) do
    case current_user(conn) do
      nil ->
        conn
        |> Phoenix.Controller.redirect(to: GameRoomWeb.Router.Helpers.home_path(conn, :index))
        |> halt()

      user ->
        conn
        |> assign(:user, user)
    end
  end

  defp current_user(conn), do: get_session(conn, :current_user)
end
