defmodule GameRoom.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :auth_key, :string, null: false, default: ""

      timestamps()
    end

    create unique_index(:users, [:auth_key])
  end
end
