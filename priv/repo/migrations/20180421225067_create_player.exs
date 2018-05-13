defmodule GameRoom.Repo.Migrations.CreatePlayer do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :repository_url, :string
      add :repository_clone_url, :string
      add :language, :string
      add :user_id, references(:users, on_delete: :nilify_all)
      add :game_id, references(:games, on_delete: :nilify_all)
      add :active, :boolean, default: false

      timestamps()
    end

    create index(:players, [:user_id])
    create index(:players, [:game_id])
  end
end
