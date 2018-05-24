defmodule GameRoom.PlayerContainer.TicTacToe do
  def command(%{current_state: current_state, next_turn: next_turn}) do
    "sh -c 'mix run -e \"IO.puts TicTacToe.play(#{inspect(current_state)}, #{inspect(next_turn)})\"'"
  end
end
