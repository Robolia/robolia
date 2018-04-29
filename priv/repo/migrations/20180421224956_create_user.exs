defmodule GameRoom.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false, default: ""
      add :github_id, :integer, null: false

      timestamps()
    end

    create unique_index(:users, [:github_id])
  end
end
