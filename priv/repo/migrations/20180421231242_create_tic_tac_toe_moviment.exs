defmodule Robolia.Repo.Migrations.CreateTicTacToeMoviment do
  use Ecto.Migration

  def change do
    create table(:tic_tac_toe_moviments) do
      add :position, :integer
      add :turn, :integer
      add :tic_tac_toe_match_id, references(:tic_tac_toe_matches, on_delete: :nilify_all)
      add :player_id, references(:players, on_delete: :nilify_all)
      add :valid, :boolean, default: true
      add :details, :string, default: nil

      timestamps()
    end

    create index(:tic_tac_toe_moviments, [:tic_tac_toe_match_id])
    create index(:tic_tac_toe_moviments, [:player_id])
    create unique_index(:tic_tac_toe_moviments, [:position, :tic_tac_toe_match_id])
    create unique_index(:tic_tac_toe_moviments, [:turn, :tic_tac_toe_match_id])
  end
end
