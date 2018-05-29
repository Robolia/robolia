defmodule GameRoom.RedisClient do
  use Confex, otp_app: :game_room

  @spec run(list()) :: {:ok, any()} | {:error, atom()}
  def run(command) do
    with {:ok, conn} <- connect(),
         {:ok, result} = conn |> command(command),
         :ok <- stop(conn) do
      result
    else
      {:error, error} ->
        require Logger
        Logger.error("Error on running Redis command #{inspect(command)}: #{inspect(error)}")
        nil
    end
  end

  @spec command(pid(), list()) :: {:ok, any()} | {:error, atom()}
  def command(conn, params), do: redis().command(conn, params)

  @spec connect() :: {:ok, pid()} | {:error, any()}
  def connect, do: redis().start_link(uri_connection(), sync_connect: true)

  @spec stop(pid()) :: :ok
  def stop(conn), do: redis().stop(conn)

  defp uri_connection, do: config()[:uri_connection]
  defp redis, do: config()[:redis_client]
end
