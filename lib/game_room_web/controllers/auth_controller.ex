defmodule GameRoomWeb.AuthController do
  use GameRoomWeb, :controller
  plug(Ueberauth)

  alias GameRoomWeb.{UserFromProvider, AuthUser}
  alias GameRoom.Accounts
  alias GameRoom.Accounts.Queries
  alias GameRoom.Repo

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case UserFromProvider.find_or_create(auth) do
      {:ok, github_user} ->
        conn =
          case Queries.for_github(%{id: github_user.id}) |> Repo.one() do
            nil ->
              Accounts.create_user!(%{name: github_user.name, github_id: github_user.id})
              |> authenticate(github_user, conn)

            user ->
              user |> authenticate(github_user, conn)
          end

        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> redirect(to: "/")

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end

  defp authenticate(user, github_user, conn) do
    auth_user = %AuthUser{name: user.name, avatar: github_user.avatar, id: user.id}
    conn |> put_session(:current_user, auth_user)
  end
end
