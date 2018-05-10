defmodule GameRoom.Games.Queries do
  import Ecto.Query, only: [from: 2]
  alias GameRoom.Repo
  alias GameRoom.Accounts.Player
  alias GameRoom.Games.Game

  def for_game(query, %{id: game_id}) do
    from(
      q in query,
      where: q.id == ^game_id
    )
  end

  def for_game(query, %{slug: game_slug}) do
    from(
      q in query,
      where: q.slug == ^game_slug
    )
  end

  def count_active_bots_per_game do
    from(
      p in Player,
      join: g in Game,
      where: g.id == p.game_id,
      group_by: g.slug,
      select: {g.slug, count(p.id)}
    )
  end

  def count(query) do
    query |> Repo.aggregate(:count, :id)
  end
end
