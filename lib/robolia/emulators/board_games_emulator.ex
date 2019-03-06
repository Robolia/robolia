defmodule Robolia.Emulators.BoardGamesEmulator do
  alias Phoenix.PubSub
  alias Robolia.{GameError, Repo}

  def run_match(%{players: {p1, p2} = players, game: game, game_aggregator: game_aggregator, config: config}) do
    build_container_for(%{game: game, players: players})

    match =
      %{
        first_player_id: p1.id,
        second_player_id: p2.id,
        next_player_id: p1.id,
        game_id: game.id
      }
      |> game_aggregator.create_match!()
      |> Repo.preload([:next_player, :game])

    {:ok, match} = run_match(%{match: match, game_aggregator: game_aggregator, config: config})

    delete_container_for(%{game: game, players: players})

    {:ok, match}
  end

  def run_match(%{match: match, game_aggregator: game_aggregator, config: %{board: board} = config}) do
    case game_aggregator.match_finished?(match) do
      {true, _} ->
        {:ok, match}

      {false, _} ->
        current_state = game_aggregator.current_state(match)
        next_turn = board.next_turn(current_state)

        game_aggregator.add_moviment!(match, %{
          position:
            fetch_player_moviment(%{
              match: match,
              current_state: current_state,
              next_turn: next_turn,
              bot_runner_adapter: config.bot_runner_adapter
            }),
          player_id: match.next_player_id,
          turn: next_turn
        })

        PubSub.broadcast(Robolia.PubSub, "moviment_created", %{
          match: match,
          event: "moviment_created"
        })

        match =
          match
          |> game_aggregator.refresh()
          |> Repo.preload([:next_player, :game])

        run_match(%{match: match, game_aggregator: game_aggregator, config: config})
    end
  rescue
    e in GameError -> {:error, e}
  end

  defp build_container_for(%{game: game, players: players}) do
    for player <- Tuple.to_list(players) do
      player_bot().build(%{game: game, player: player})
    end
  end

  defp delete_container_for(%{game: game, players: players}) do
    for player <- Tuple.to_list(players) do
      player_bot().delete(%{game: game, player: player})
    end
  end

  defp fetch_player_moviment(%{match: match, current_state: current_state, next_turn: next_turn, bot_runner_adapter: runner_adapter}) do
    player_bot().run(%{
      player: match.next_player,
      current_state: current_state,
      next_turn: next_turn,
      runner_adapter: runner_adapter
    })
  rescue
    _ -> nil
  end

  defp player_bot(), do: Application.get_env(:robolia, :player_bot_runner)
end
