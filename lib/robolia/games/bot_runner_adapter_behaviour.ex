defmodule Robolia.Games.BotRunnerAdapterBehaviour do
  @moduledoc "Define the behaviour for bot runner adapters on each game"

  @callback command(%{language: String.t(), current_state: map(), next_turn: integer()}) :: nil | String.t()
  @callback parse_bot_response(any()) :: integer() | String.t() | nil
end
