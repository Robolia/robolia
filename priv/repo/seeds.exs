# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     GameRoom.Repo.insert!(%GameRoom.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias GameRoom.Accounts

repo_url = "git@github.com:game-room-space/tic_tac_toe_elixir_example.git"

game = GameRoom.Games.create_game!(%{name: "Tic Tac Toe"})

user1 = Accounts.create_user!(%{name: "Rafael"})
user2 = Accounts.create_user!(%{name: "Luiz"})

Accounts.create_player!(%{user_id: user1.id, repository_url: repo_url, language: "elixir", game_id: game.id})
Accounts.create_player!(%{user_id: user2.id, repository_url: repo_url, language: "elixir", game_id: game.id})
