defmodule GameRoom.Accounts.Player do
  use Ecto.Schema
  import Ecto.Changeset
  alias GameRoom.Accounts.User

  schema "players" do
    field(:repository_url, :string)
    field(:language, :string)
    belongs_to(:game, User, foreign_key: :game_id)
    belongs_to(:user, User, foreign_key: :user_id)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:repository_url, :game_id, :language, :user_id])
    |> validate_required([:repository_url, :game_id, :language, :user_id])
  end
end
