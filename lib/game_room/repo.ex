defmodule GameRoom.Repo do
  use Ecto.Repo, otp_app: :game_room

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, env} = Confex.fetch_env(:game_room, GameRoom.Repo)
    {:ok, Keyword.merge(opts, env)}
  end
end
