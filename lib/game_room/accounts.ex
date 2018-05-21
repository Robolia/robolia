defmodule GameRoom.Accounts do
  alias GameRoom.Accounts.{User, Player, PlayerRating}
  alias GameRoom.Repo
  alias RoboliaRating.Elo, as: EloRating
  alias GameRoom.RedisClient

  def create_user!(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert!()
  end

  def create_player!(attrs) do
    player = %Player{}
    |> Player.changeset(attrs)
    |> Repo.insert!()

    create_player_rating(%{
      player_id: player.id,
      game_id: player.game_id,
      rating: EloRating.initial_rating()
    })
  end

  def create_player_rating(attrs) do
    {:ok, player_rating} = %PlayerRating{}
    |> PlayerRating.changeset(attrs)
    |> Repo.insert()

    redis_run(["ZADD", "players_rank", player_rating.rating, player_rating.player_id])

    player_rating
  end

  def update_player_rating(%PlayerRating{} = player_rating, %{new_rating: new_rating}) do
    update = Ecto.Changeset.change(player_rating, %{rating: new_rating})
    |> Repo.update()

    redis_run(["ZADD", "players_rank", new_rating, player_rating.player_id])

    update
  end

  def current_rank(%Player{} = player) do
    %{position: redis_run(["ZREVRANK", "players_rank", player.id]) + 1, rating: player.rating.rating}
  end

  defp redis_run(command) do
    {:ok, conn} = RedisClient.connect()
    {:ok, result} = conn |> RedisClient.command(command)
    result
  end
end
