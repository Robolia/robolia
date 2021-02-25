defmodule Robolia.Repo.Migrations.CreateChessMovement do
  use Ecto.Migration

  def change do
    create table(:chess_movements) do
      add :position, :string
      add :turn, :integer
      add :chess_match_id, references(:chess_matches, on_delete: :nilify_all)
      add :player_id, references(:players, on_delete: :nilify_all)
      add :valid, :boolean, default: true
      add :details, :string, default: nil

      timestamps()
    end

    create index(:chess_movements, [:chess_match_id])
    create index(:chess_movements, [:player_id])
    create unique_index(:chess_movements, [:turn, :chess_match_id])
  end
end
