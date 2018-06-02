defmodule RoboliaWeb.AuthController do
  use RoboliaWeb, :controller
  plug(Ueberauth)

  alias RoboliaWeb.{UserFromProvider, AuthUser}
  alias Robolia.Accounts
  alias Robolia.Accounts.Queries
  alias Robolia.Repo

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
      {:ok, %{id: github_id, name: name, avatar: avatar_url} = github_user} ->
        conn =
          case Queries.for_github(%{id: github_id}) |> Repo.one() do
            nil ->
              Accounts.create_user!(%{name: name, github_id: github_id, avatar_url: avatar_url})
              |> authenticate(conn)

            user ->
              user
              |> maybe_update_user(github_user)
              |> authenticate(conn)
          end

        conn
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

  defp maybe_update_user(user, %{name: name, avatar: avatar_url}) do
    user = Ecto.Changeset.change(user, name: name, avatar_url: avatar_url)

    case Repo.update(user) do
      {:ok, updated} ->
        updated

      {:error, changeset} ->
        require Logger
        Logger.error("Error updating user: #{changeset}")
    end
  end
end
