defmodule GameRoom.Repo.Migrations.CreateGameRepository do
  use Ecto.Migration

  def change do
    create table(:game_repositories) do
      add :repository_url, :string
      add :language, :string
      add :image_url, :string
      add :game_id, references(:games, on_delete: :nilify_all)

      timestamps()
    end

    create index(:game_repositories, [:game_id])
  end
end
