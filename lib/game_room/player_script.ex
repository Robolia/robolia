defmodule GameRoom.PlayerScript do
  @callback build(data :: map()) :: list()
  def build(%{game: %{slug: game_slug}, player: player}) do
    """
    docker build -t #{game_slug}:#{player.id} \
                 -f Dockerfile_#{player.language} \
                 --build-arg player_repo_url=#{player.repository_clone_url} .
    """
    |> run_cmd
  end

  @callback run(data :: map()) :: list()
  def run(%{
        game_slug: game_slug,
        player: player,
        current_state: current_state,
        next_turn: next_turn
      }) do
    """
    docker run -i #{game_slug}:#{player.id} \
      sh -c 'mix run -e "IO.puts TicTacToe.play(#{inspect(current_state)}, #{inspect(next_turn)})"'
    """
    |> run_cmd
  end

  defp run_cmd(string) do
    string
    |> String.trim()
    |> to_charlist
    |> :os.cmd()
  end
end
