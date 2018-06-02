defmodule Robolia.PlayerContainer.TicTacToe do
  def command(%{language: "elixir", current_state: current_state, next_turn: next_turn}) do
    "sh -c 'mix run -e \"IO.puts TicTacToe.play(#{inspect(current_state)}, #{inspect(next_turn)})\"'"
  end

  def command(_), do: nil
end
