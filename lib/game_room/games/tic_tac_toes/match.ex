defmodule GameRoom.Games.TicTacToes.Match do
  alias GameRoom.Games.TicTacToes
  alias GameRoom.GameError
  alias GameRoom.Repo

  def play(match) do
    case TicTacToes.match_finished?(match) do
      {true, _} ->
        {:ok, match}

      {false, _} ->
        current_state = match |> TicTacToes.current_state()
        next_turn = match |> TicTacToes.next_turn()

        try do
          player_moviment = fetch_player_moviment(%{
            match: match,
            current_state: current_state,
            next_turn: next_turn
          })

          match
          |> TicTacToes.add_moviment!(%{
            position: player_moviment,
            player_id: match.next_player.id,
            turn: next_turn
          })
        rescue
          _ ->
            match
            |> TicTacToes.add_moviment!(%{
              position: nil,
              player_id: match.next_player.id,
              turn: next_turn
            })
        end

        match
        |> TicTacToes.refresh()
        |> Repo.preload([:next_player, :game])
        |> __MODULE__.play()
    end
  rescue
    e in GameError -> {:error, e}
  end

  def calculate_winner(match) do
    match = match |> Repo.preload([:first_player, :second_player])

    winner =
      %{
        current_state: TicTacToes.current_state(match),
        first_player: match.first_player,
        second_player: match.second_player
      }
      |> GameRoom.Games.TicTacToes.Match.Winner.calculate()

    case winner do
      nil ->
        {:error, nil}

      winner ->
        {:ok, winner}
    end
  end


  defp fetch_player_moviment(%{match: match, current_state: current_state, next_turn: next_turn}) do
    player_script().run(%{
      game_slug: match.game.slug,
      player: match.next_player,
      current_state: current_state,
      next_turn: next_turn
    })
    |> to_string
    |> String.trim()
    |> Integer.parse()
    |> elem(0)
  end

  defp player_script(), do: Application.get_env(:game_room, :player_script_runner)
end
