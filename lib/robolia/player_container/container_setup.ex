defmodule Robolia.PlayerContainer.ContainerSetup do
  def generate_command(%{language: "elixir", container_id: container_id}) do
    "docker container exec #{container_id} mix compile"
  end

  def generate_command(attrs) do
    require Logger
    Logger.warn("[#{__MODULE__}] No match found setting up the container with: #{inspect attrs}")
  end
end
