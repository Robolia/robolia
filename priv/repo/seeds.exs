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
game = GameRoom.Games.create_game!(%{name: "Tic Tac Toe"})

if Mix.env() == :dev do
  user1 = GameRoom.Accounts.create_user!(%{
    name: "Rafael Soares",
    github_id: 438257,
    avatar_url: "https://avatars1.githubusercontent.com/u/438257?s=400&u=17a971c8ae0e64b56d104b87eee16917547b418c&v=4"
  })
  GameRoom.Accounts.create_player!(%{
    repository_url: "git@github.com:Robolia/tic-tac-toe-elixir-example.git",
    language: "elixir",
    game_id: game.id,
    user_id: user1.id
  })

  user2 = GameRoom.Accounts.create_user!(%{
    name: "Leandro Bighetti",
    github_id: 234,
    avatar_url: "https://avatars0.githubusercontent.com/u/2095914?s=460&v=4"
  })
  GameRoom.Accounts.create_player!(%{
    repository_url: "git@github.com:Robolia/tic-tac-toe-elixir-example.git",
    language: "elixir",
    game_id: game.id,
    user_id: user2.id
  })
end
