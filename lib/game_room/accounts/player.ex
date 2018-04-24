defmodule GameRoom.Accounts.Player do
  use Ecto.Schema
  import Ecto.Changeset
  alias GameRoom.Accounts.User

  schema "players" do
    field :repository, :string
    field :game, :string
    belongs_to :user, User, foreign_key: :user_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:repository, :game])
    |> validate_required([:repository, :game])
  end
end
