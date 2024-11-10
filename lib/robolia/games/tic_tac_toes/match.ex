defmodule Robolia.Games.TicTacToes.Match do
  alias Phoenix.PubSub
  alias TicTacToeBoard
  alias Robolia.Games.TicTacToes
  alias Robolia.GameError
  alias Robolia.Repo
  alias Robolia.PlayerContainer.TicTacToe, as: BotRunner

  def play(match) do
    case TicTacToes.match_finished?(match) do
      {true, _} ->
        {:ok, match}

      {false, _} ->
        current_state = TicTacToes.current_state(match)
        next_turn = TicTacToeBoard.next_turn(current_state)

        TicTacToes.add_moviment!(match, %{
          position:
            fetch_player_moviment(%{
              match: match,
              current_state: current_state,
              next_turn: next_turn
            }),
          player_id: match.next_player_id,
          turn: next_turn
        })

        PubSub.broadcast(Robolia.PubSub, "moviment_created", %{match: match, event: "moviment_created"})

        match
        |> TicTacToes.refresh()
        |> Repo.preload([:next_player, :game])
        |> __MODULE__.play()
    end
  rescue
    e in GameError -> {:error, e}
  end

  defp fetch_player_moviment(%{match: match, current_state: current_state, next_turn: next_turn}) do
    player_script().run(%{
      player: match.next_player,
      current_state: current_state,
      next_turn: next_turn,
      bot_runner: BotRunner
    })
    |> to_string
    |> String.trim()
    |> Integer.parse()
    |> elem(0)
  rescue
    _ -> nil
  end

  defp player_script(), do: Application.get_env(:robolia, :player_script_runner)
end
