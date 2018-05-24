defmodule GameRoom.PlayerContainer do
  @callback build(data :: map()) :: list()
  def build(%{game: %{slug: game_slug}, player: player}) do
    """
    cd #{docker_files_dir()} && \
    docker build --tag=#{game_slug}:#{player.id} \
                 -f=Dockerfile_#{player.language} \
                 --build-arg player_repo_url=#{player.repository_clone_url} .
    """
    |> run_cmd
  end

  @callback run(data :: map()) :: list()
  def run(%{
        game: %{slug: game_slug},
        player: %{id: player_id},
        current_state: current_state,
        next_turn: next_turn,
        bot_runner: bot_runner
      }) do
    command = bot_runner.command(%{current_state: current_state, next_turn: next_turn})

    "docker run -i #{game_slug}:#{player_id} #{command}" |> run_cmd
  end

  def delete(%{game: %{slug: game_slug}, player: player}) do
    "docker rmi #{game_slug}:#{player.id} -f" |> run_cmd
  end

  defp run_cmd(string) do
    string
    |> String.trim()
    |> to_charlist
    |> :os.cmd()
  end

  defp docker_files_dir do
    Path.join(:code.priv_dir(:game_room), "dockerfiles/")
  end
end
