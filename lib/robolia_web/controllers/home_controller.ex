defmodule RoboliaWeb.HomeController do
  use RoboliaWeb, :controller

  def index(conn, _params) do
    case current_user(conn) do
      nil ->
        conn |> render("index.html", current_user: nil)

      _ ->
        conn |> redirect(to: matches_path(conn, :index))
    end
  end

  defp current_user(conn), do: get_session(conn, :current_user)
end
