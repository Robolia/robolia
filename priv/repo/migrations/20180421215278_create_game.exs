defmodule Robolia.Repo.Migrations.CreateGame do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :name, :string
      add :slug, :string
      add :image_url, :string

      timestamps()
    end

    create unique_index(:games, [:slug])
  end
end
