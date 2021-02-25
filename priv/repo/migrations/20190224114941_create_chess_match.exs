defmodule Robolia.Repo.Migrations.CreateChessMatch do
  use Ecto.Migration

  def change do
    create table(:chess_matches) do
      add :first_player_id, references(:players, on_delete: :nilify_all), null: false
      add :second_player_id, references(:players, on_delete: :nilify_all), null: false
      add :winner_id, references(:players, on_delete: :nilify_all), null: true
      add :next_player_id, references(:players, on_delete: :nilify_all), null: true
      add :game_id, references(:games, on_delete: :nilify_all), null: true
      # 0 - Ongoing; 1 - Draw; 2 - Winner
      add :status, :integer, default: 0
      add :finished_at, :utc_datetime, default: nil

      timestamps()
    end

    create index(:chess_matches, [:first_player_id])
    create index(:chess_matches, [:second_player_id])
    create index(:chess_matches, [:winner_id])
    create index(:chess_matches, [:next_player_id])
    create index(:chess_matches, [:game_id])
  end
end
