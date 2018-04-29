defmodule GameRoom.Accounts.Queries do
  import Ecto.Query, only: [from: 2]
  alias GameRoom.Accounts.{Player, User}

  def for_game(Player = model, %{game_id: game_id}) do
    from(
      p in model,
      where: p.game_id == ^game_id
    )
  end

  def for_github(%{id: _} = filter), do: User |> for_github(filter)

  def for_github(User = model, %{id: github_id}) do
    from(
      m in model,
      where: m.github_id == ^github_id
    )
  end
end
