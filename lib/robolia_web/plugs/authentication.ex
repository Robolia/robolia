defmodule RoboliaWeb.Plugs.Authentication do
  import Plug.Conn
  use Phoenix.VerifiedRoutes, endpoint: RoboliaWeb.Endpoint, router: RoboliaWeb.Router

  def init(default), do: default

  def call(conn, _) do
    case current_user(conn) do
      nil ->
        conn
        |> Phoenix.Controller.redirect(to: ~p"/")
        |> halt()

      user ->
        conn
        |> assign(:user, user)
    end
  end

  defp current_user(conn), do: get_session(conn, :current_user)
end
