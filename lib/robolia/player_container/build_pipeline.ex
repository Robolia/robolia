defmodule Robolia.PlayerContainer.BuildPipeline do
  require Logger
  use Opus.Pipeline
  alias Robolia.PlayerContainer.{Register, ContainerSetup}

  @resource_limit_options "--cpus=0.3 --memory=100m --network=none"

  check :valid_params?, with: &match?(%{game: %{id: _}, player: %{id: _}}, &1)

  step(:assign_language)
  step(:clone_player_bot)
  step(:create_bot_container)
  step(:start_bot_container)
  step(:copy_bot_to_container)
  step(:prepare_bot_to_run)
  step(:register_new_container)

  def clone_player_bot(%{game: game, player: player} = pipeline) do
    bot_local_storage_path = "/tmp/robolia/#{game.id}/#{player.id}/"

    Logger.debug("[#{__MODULE__}] Cloning bot from #{player.repository_clone_url} to #{bot_local_storage_path}")
    result = run_cmd("git clone #{player.repository_clone_url} #{bot_local_storage_path}")

    Logger.debug("[#{__MODULE__}] Clone bot: #{inspect(result)}")
    put_in(pipeline, [:bot_local_storage_path], bot_local_storage_path)
  end

  def create_bot_container(%{language: language} = pipeline) do
    container_id =
      run_cmd("docker container create #{@resource_limit_options} -it robolia:#{language}")

    Logger.debug("[#{__MODULE__}] Container created: #{container_id}")
    put_in(pipeline, [:container_id], container_id)
  end

  def start_bot_container(%{container_id: container_id} = pipeline) do
    result = run_cmd("docker container start #{container_id}")

    Logger.debug("[#{__MODULE__}] Start bot: #{inspect(result)}")
    pipeline
  end

  def copy_bot_to_container(
        %{
          container_id: container_id,
          bot_local_storage_path: bot_local_storage_path
        } = pipeline
      ) do
    cmd = "docker cp #{bot_local_storage_path}. #{container_id}:/app"
    Logger.debug("[#{__MODULE__}] Copying bot to container (#{cmd})")

    result = run_cmd("docker cp #{bot_local_storage_path}. #{container_id}:/app")

    Logger.debug("[#{__MODULE__}] Copied bot to container: #{inspect(result)}")
    pipeline
  end

  def prepare_bot_to_run(pipeline) do
    cmd = ContainerSetup.generate_command(pipeline)

    if !is_nil(cmd) do
      result = run_cmd(cmd)
      Logger.debug("[#{__MODULE__}] Preparation result: #{inspect(result)} for #{inspect(cmd)}")
    end

    pipeline
  end

  def register_new_container(%{container_id: container_id, player: %{id: player_id}}) do
    result = Register.new_for(container_id, player_id)
    Logger.debug("[#{__MODULE__}] Register new container: #{inspect(result)}")
  end

  def assign_language(%{player: %{language: language}} = pipeline),
    do: put_in(pipeline, [:language], to_string(language))

  defp run_cmd(command) do
    command
    |> to_charlist
    |> :os.cmd()
    |> to_string
    |> String.trim()
  end
end
