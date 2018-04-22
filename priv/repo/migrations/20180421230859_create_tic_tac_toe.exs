defmodule GameRoom.Repo.Migrations.CreateTicTacToe do
  use Ecto.Migration

  def change do
    create table(:tic_tac_toes) do
      add :first_player_id, references(:users, on_delete: :nilify_all), null: false
      add :second_player_id, references(:users, on_delete: :nilify_all), null: false
      add :winner_id, references(:users, on_delete: :nilify_all), null: true
      add :next_player_id, references(:users, on_delete: :nilify_all), null: true

      timestamps()
    end

    create index(:tic_tac_toes, [:first_player_id])
    create index(:tic_tac_toes, [:second_player_id])
    create index(:tic_tac_toes, [:winner_id])
    create index(:tic_tac_toes, [:next_player_id])
  end
end
