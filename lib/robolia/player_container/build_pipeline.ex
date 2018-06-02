defmodule Robolia.PlayerContainer.BuildPipeline do
  use Opus.Pipeline
  alias Robolia.PlayerContainer.Register
  require Logger

  check :valid_params?, with: &match?(%{game: %{id: _}, player: %{id: _}}, &1)

  step(:clone_player_bot)
  step(:create_bot_container)
  step(:start_bot_container)
  step(:copy_bot_to_container)
  step(:prepare_bot_to_run)
  step(:register_new_container)

  def clone_player_bot(%{game: game, player: player} = pipeline) do
    bot_local_storage_path = "/tmp/robolia/#{game.id}/#{player.id}/"

    result =
      "git clone #{player.repository_clone_url} #{bot_local_storage_path}"
      |> run_cmd

    Logger.info("[#{__MODULE__}] Clone bot: #{result}")
    pipeline |> put_in([:bot_local_storage_path], bot_local_storage_path)
  end

  def create_bot_container(%{player: %{language: language}} = pipeline) do
    container_id =
      "docker container create robolia:#{language}"
      |> run_cmd

    Logger.info("[#{__MODULE__}] Container created: #{container_id}")
    pipeline |> put_in([:container_id], container_id)
  end

  def start_bot_container(%{container_id: container_id} = pipeline) do
    result =
      "docker container start #{container_id}"
      |> run_cmd

    Logger.info("[#{__MODULE__}] Start bot: #{result}")
    pipeline
  end

  def copy_bot_to_container(
        %{
          container_id: container_id,
          bot_local_storage_path: bot_local_storage_path
        } = pipeline
      ) do
    cmd = "docker cp #{bot_local_storage_path}. #{container_id}:/app"
    Logger.info("[#{__MODULE__}] Copying bot to container (#{cmd})")

    result =
      "docker cp #{bot_local_storage_path}. #{container_id}:/app"
      |> run_cmd

    Logger.info("[#{__MODULE__}] Copied bot to container: #{result}")
    pipeline
  end

  def prepare_bot_to_run(%{container_id: container_id} = pipeline) do
    result =
      "docker container exec #{container_id} mix compile"
      |> run_cmd

    Logger.info("[#{__MODULE__}] Compile: #{result}")
    pipeline
  end

  def register_new_container(%{container_id: container_id, player: %{id: player_id}}) do
    result = container_id |> Register.new_for(player_id)
    Logger.info("[#{__MODULE__}] Register new container: #{result}")
  end

  defp run_cmd(command) do
    command
    |> to_charlist
    |> :os.cmd()
    |> to_string
    |> String.trim()
  end
end
