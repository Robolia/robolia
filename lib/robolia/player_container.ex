defmodule Robolia.PlayerContainer do
  alias Robolia.PlayerContainer.{BuildPipeline, Register}
  require Logger

  @callback build(data :: map()) :: {:ok, any()} | {:error, any()}
  def build(%{game: _, player: _} = build_attrs), do: BuildPipeline.call(build_attrs)

  @callback run(data :: map()) :: list()
  def run(%{
        player: %{id: player_id, language: language},
        current_state: current_state,
        next_turn: next_turn,
        bot_runner: bot_runner
      }) do
    bot_command =
      bot_runner.command(%{language: language, current_state: current_state, next_turn: next_turn})

    container_id = Register.container_id_for(player_id)

    Logger.info("docker container exec #{container_id} #{bot_command}")
    "docker container exec #{container_id} #{bot_command}" |> run_cmd
  end

  def delete(%{game: %{id: game_id}, player: %{id: player_id}}) do
    container_id = Register.container_id_for(player_id)
    bot_local_storage_path = "/tmp/robolia/#{game_id}/#{player_id}/"

    "docker rm #{container_id} --force" |> run_cmd
    "rm -rf #{bot_local_storage_path}" |> run_cmd
    Register.delete(player_id)
  end

  defp run_cmd(string) do
    string
    |> String.trim()
    |> to_charlist
    |> :os.cmd()
  end
end
