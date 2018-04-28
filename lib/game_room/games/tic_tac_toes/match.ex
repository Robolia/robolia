defmodule GameRoom.Games.TicTacToes.Match do
  use Confex, otp_app: :game_room
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

        player_moviment =
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

        match
        |> TicTacToes.add_moviment!(%{position: player_moviment, player_id: match.next_player.id})

        match
        |> TicTacToes.refresh()
        |> Repo.preload([:next_player, :game])
        |> __MODULE__.play()
    end
  rescue
    e in GameError -> {:error, e}
  end

  def calculate_winner(_match) do
    {:error, nil}
  end

  defp player_script(), do: Application.get_env(:game_room, :player_script_runner)
end
