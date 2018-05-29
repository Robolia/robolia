defmodule GameRoom.Games.TicTacToes.Match do
  alias TicTacToeBoard
  alias GameRoom.Games.TicTacToes
  alias GameRoom.GameError
  alias GameRoom.Repo
  alias GameRoom.PlayerContainer.TicTacToe, as: BotRunner

  def play(match) do
    case TicTacToes.match_finished?(match) do
      {true, _} ->
        {:ok, match}

      {false, _} ->
        current_state = match |> TicTacToes.current_state()
        next_turn = current_state |> TicTacToeBoard.next_turn()

        match
        |> TicTacToes.add_moviment!(%{
          position:
            fetch_player_moviment(%{
              match: match,
              current_state: current_state,
              next_turn: next_turn
            }),
          player_id: match.next_player_id,
          turn: next_turn
        })

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

  defp player_script(), do: Application.get_env(:game_room, :player_script_runner)
end
