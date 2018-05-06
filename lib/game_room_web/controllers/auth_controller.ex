defmodule GameRoomWeb.AuthController do
  use GameRoomWeb, :controller
  plug(Ueberauth)

  alias GameRoomWeb.{UserFromProvider, AuthUser}
  alias GameRoom.Accounts
  alias GameRoom.Accounts.Queries
  alias GameRoom.Repo

  def delete(conn, _params) do
    conn
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
              IO.inspect(github_user)

              Accounts.create_user!(%{name: github_user.name, github_id: github_user.id})
              |> authenticate(conn)

            user ->
              user
              |> maybe_update_user(github_user)
              |> authenticate(conn)
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

  defp authenticate(user, conn) do
    auth_user = %AuthUser{name: user.name, avatar: user.avatar_url, id: user.id}
    conn |> put_session(:current_user, auth_user)
  end

  defp maybe_update_user(user, github_user) do
    user = Ecto.Changeset.change(user, name: github_user.name, avatar_url: github_user.avatar)

    case Repo.update(user) do
      {:ok, updated} ->
        updated

      {:error, changeset} ->
        require Logger
        Logger.error("Error updating user: #{changeset}")
    end
  end
end
