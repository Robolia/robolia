defmodule GameRoom.Accounts do
  alias GameRoom.Accounts.{User, Player}
  alias GameRoom.Repo

  def create_user!(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert!()
  end

  def create_player!(attrs) do
    %Player{}
    |> Player.changeset(attrs)
    |> Repo.insert!()
  end
end
