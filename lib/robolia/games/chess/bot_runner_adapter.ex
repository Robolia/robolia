defmodule Robolia.Games.Chess.BotRunnerAdapter do
  import Robolia.Data, only: [into_python_repr: 1]

  alias Robolia.Games.BotRunnerAdapterBehaviour
  @behaviour BotRunnerAdapterBehaviour

  @impl BotRunnerAdapterBehaviour
  def command(%{language: "elixir", current_state: board, next_turn: next_turn}) do
    "sh -c 'mix run -e \"IO.puts Chess.play(#{inspect(board)}, #{inspect(next_turn)})\"'"
  end

  @impl BotRunnerAdapterBehaviour
  def command(%{language: "python", current_state: board, next_turn: next_turn}) do
    """
    sh -c 'python chess.py #{inspect(into_python_repr(board))} #{inspect(next_turn)}'
    """
  end

  @impl BotRunnerAdapterBehaviour
  def command(_), do: nil

  @impl BotRunnerAdapterBehaviour
  def parse_bot_response(response) do
    response
    |> to_string()
    |> String.trim()
    |> String.downcase()
  end
end
