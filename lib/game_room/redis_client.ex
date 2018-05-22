defmodule GameRoom.RedisClient do
  use Confex, otp_app: :game_room

  @spec command(pid(), list()) :: {:ok, any()} | {:error, atom()}
  def command(conn, params), do: redis().command(conn, params)

  @spec connect() :: {:ok, pid()} | {:error, any()}
  def connect, do: redis().start_link(uri_connection(), [sync_connect: true])

  defp uri_connection, do: config()[:uri_connection]
  defp redis, do: config()[:redis_client]
end
