defmodule Robolia.PlayerContainer.ImagesSetup do
  use GenServer
  use Confex, otp_app: :robolia

  def start_link(name \\ __MODULE__, state \\ []) do
    GenServer.start_link(name, state)
  end

  def init(state) do
    send(self(), :build_images)
    {:ok, state}
  end

  def handle_info(:build_images, state) do
    languages() |> Enum.each(&build/1)
    {:noreply, state}
  end

  def build(language) do
    require Logger
    Logger.info("[#{__MODULE__}] Building Docker Image for #{inspect(language)}, please wait...")

    "cd #{docker_files_dir()} && docker build --tag=robolia:#{language} -f=Dockerfile_#{language} ."
    |> to_charlist
    |> :os.cmd()

    Logger.info("[#{__MODULE__}] Docker Image for #{inspect(language)} created.")
  end

  def languages, do: config()[:languages]

  def docker_files_dir do
    Path.join(:code.priv_dir(:robolia), "dockerfiles/")
  end
end
