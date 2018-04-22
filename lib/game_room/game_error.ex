defmodule GameRoom.GameError do
  defexception [:exception]

  def message(%{exception: exception}) do
    "Game Operation Error: #{inspect exception}"
  end
end
