defmodule Robolia.Accounts.Queries do
  import Ecto.Query, only: [from: 2]
  alias Robolia.Accounts.{Player, User, PlayerRating}
  alias Robolia.Games.Game

  def for_game(query, %{game_id: game_id}) do
    from(
      q in query,
      where: q.game_id == ^game_id
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

  def for_player(PlayerRating = query, %{id: player_id}) do
    from(
      q in query,
      where: q.player_id == ^player_id
    )
  end

  def for_player(query, %{id: player_id}) do
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

  def count_bots_per_game do
    from(
      p in Player,
      join: g in Game,
      where: g.id == p.game_id,
      group_by: g.slug,
      select: {g.slug, count(p.id)}
    )
  end

  def count_bots_per_language(game = %Game{}) do
    from(
      p in Player,
      where: p.game_id == ^game.id,
      group_by: p.language,
      select: {p.language, count(p.id)}
    )
  end
end
