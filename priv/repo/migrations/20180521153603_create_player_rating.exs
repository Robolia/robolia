defmodule GameRoom.Repo.Migrations.CreatePlayerRating do
  use Ecto.Migration

  def change do
    create table(:player_ratings) do
      add :rating, :float
      add :player_id, references(:players, on_delete: :nothing)
      add :game_id, references(:games, on_delete: :nothing)

      timestamps()
    end

    create index(:player_ratings, [:player_id])
    create index(:player_ratings, [:game_id])
  end
end
