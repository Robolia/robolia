defmodule GameRoom.PlayerContainer.Register do
  alias GameRoom.RedisClient

  def new_for(container_id, player_id) do
    RedisClient.run(["SET", "player_#{player_id}_container", container_id])
  end

  def container_id_for(player_id) do
    RedisClient.run(["GET", "player_#{player_id}_container"])
  end

  def delete(player_id) do
    RedisClient.run(["DEL", "player_#{player_id}_container"])
  end
end
