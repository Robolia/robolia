defmodule RoboliaWeb.HomeController do
  use RoboliaWeb, :controller

  def index(conn, _params) do
    case current_user(conn) do
      nil ->
        render(conn, :index, current_user: nil)

      _ ->
        conn |> redirect(to: ~p"/matches")
    end
  end

  defp current_user(conn), do: get_session(conn, :current_user)
end
