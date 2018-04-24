defmodule GameRoom.Repo.Migrations.CreatePlayer do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :repository, :string
      add :game, :string
      add :user_id, references(:users, on_delete: :nilify_all)

      timestamps()
    end

    create index(:players, [:user_id])
  end
end
