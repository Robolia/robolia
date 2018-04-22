defmodule GameRoom.Accounts do
  alias GameRoom.Accounts.User
  alias GameRoom.Repo

  def create_user!(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert!()
  end
end
