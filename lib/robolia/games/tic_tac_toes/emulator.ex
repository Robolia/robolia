defmodule Robolia.Games.TicTacToes.Emulator do
  alias Phoenix.PubSub
  alias Boards.TicTacToeBoard
  alias Robolia.{GameError, PlayerContainer, Repo}
  alias Robolia.Games.TicTacToes
  alias Robolia.PlayerContainer.TicTacToe, as: BotRunnerAdapter

  def run_match(%{players: {p1, p2} = players, game: game, game_aggregator: game_aggregator}) do
    build_container_for(%{game: game, players: players})

    match =
      %{
        first_player_id: p1.id,
        second_player_id: p2.id,
        next_player_id: p1.id,
        game_id: game.id
      }
      |> game_aggregator.create_match!()
      |> Robolia.Repo.preload([:next_player, :game])

    {:ok, match} = run_match(%{match: match})

    delete_container_for(%{game: game, players: players})

    {:ok, match}
  end

  def run_match(%{match: match}) do
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

        match =
          match
          |> TicTacToes.refresh()
          |> Repo.preload([:next_player, :game])

        run_match(%{match: match})
    end
  rescue
    e in GameError -> {:error, e}
  end

  defp build_container_for(%{game: game, players: players}) do
    for player <- Tuple.to_list(players) do
      PlayerContainer.build(%{game: game, player: player})
    end
  end

  defp delete_container_for(%{game: game, players: players}) do
    for player <- Tuple.to_list(players) do
      PlayerContainer.delete(%{game: game, player: player})
    end
  end

  defp fetch_player_moviment(%{match: match, current_state: current_state, next_turn: next_turn}) do
    player_bot().run(%{
      player: match.next_player,
      current_state: current_state,
      next_turn: next_turn,
      runner_adapter: BotRunnerAdapter
    })
    |> to_string()
    |> String.trim()
    |> Integer.parse()
    |> elem(0)
  rescue
    _ -> nil
  end

  defp player_bot(), do: Application.get_env(:robolia, :player_bot_runner)
end
