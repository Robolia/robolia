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

  def for_user(%{id: _} = filter), do: for_user(Player, filter)

  def for_user(query, %{id: user_id}) do
    from(
      q in query,
      where: q.user_id == ^user_id
    )
  end

  def for_player(Player = query, %{id: player_id}) do
    from(
      q in query,
      where: q.id == ^player_id
    )
  end

  def active(query) do
    from(
      q in query,
      where: q.active == true
    )
  end
end
