defmodule Robolia.RedisClient do
  use Confex, otp_app: :robolia

  @connection_name :redis

  @spec run(list()) :: {:ok, any()} | {:error, atom()}
  def run(command) do
    with {:ok, result} <- redis().command(@connection_name, command) do
      result
    else
      error ->
        require Logger
        Logger.error("Error on running Redis command #{inspect(command)}: #{inspect(error)}")
        nil
    end
  end

  defp redis, do: config()[:redis_client]
end
