defmodule Robolia.PlayerContainer.TicTacToe do
  import Robolia.Data, only: [into_python_repr: 1]

  def command(%{language: "elixir", current_state: board, next_turn: next_turn}) do
    "sh -c 'mix run -e \"IO.puts TicTacToe.play(#{inspect(board)}, #{inspect(next_turn)})\"'"
  end

  def command(%{language: "python", current_state: board, next_turn: next_turn}) do
    """
    sh -c 'python tictactoe.py #{inspect(into_python_repr(board))} #{inspect(next_turn)}'
    """
  end

  def command(_), do: nil
end
