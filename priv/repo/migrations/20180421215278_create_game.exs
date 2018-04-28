defmodule GameRoom.Repo.Migrations.CreateGame do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :name, :string
      add :slug, :string

      timestamps()
    end

    create unique_index(:games, [:slug])
  end
end
