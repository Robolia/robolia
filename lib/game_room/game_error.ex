defmodule GameRoom.GameError do
  defexception [:exception, :message]

  def message(%{exception: exception, message: message}) when is_bitstring(message) do
    "Game Operation Error with message: #{message} - Backtrace: #{inspect(exception)}"
  end

  def message(%{exception: exception}) do
    "Game Operation Error: #{inspect(exception)}"
  end
end
