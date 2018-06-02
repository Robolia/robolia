defmodule Robolia.Repo do
  use Ecto.Repo, otp_app: :robolia

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, env} = Confex.fetch_env(:robolia, Robolia.Repo)
    {:ok, Keyword.merge(opts, env)}
  end
end
