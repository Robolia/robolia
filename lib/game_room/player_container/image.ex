defmodule GameRoom.PlayerContainer.Image do
  use GenServer
  use Confex, otp_app: :game_room

  def start_link(name \\ __MODULE__, state \\ []) do
    GenServer.start_link(name, state)
  end

  def init(state) do
    languages() |> Enum.each(&build/1)
    {:ok, state}
  end

  defp build(language) do
    "cd #{docker_files_dir()} && docker build --tag=robolia:#{language} -f=Dockerfile_#{language} ."
    |> to_charlist
    |> :os.cmd()
  end

  defp languages, do: config()[:languages]

  defp docker_files_dir do
    Path.join(:code.priv_dir(:game_room), "dockerfiles/")
  end
end
