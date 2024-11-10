defmodule Robolia.PlayerContainer.ContainerSetup do
  def generate_command(%{language: "elixir", container_id: container_id}) do
    "docker container exec #{container_id} mix compile"
  end

  def generate_command(_), do: nil
end
