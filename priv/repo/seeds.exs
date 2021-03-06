# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Robolia.Repo.insert!(%Robolia.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
game = Robolia.Games.create_game!(%{
  name: "Tic Tac Toe",
  image_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/32/Tic_tac_toe.svg/2000px-Tic_tac_toe.svg.png"
})

{:ok, _} = %Robolia.Games.GameRepository{
  repository_url: "https://github.com/Robolia/tic-tac-toe-elixir",
  language: "elixir",
  image_url: "https://avatars0.githubusercontent.com/u/1481354",
  game_id: game.id
} |> Robolia.Repo.insert()

{:ok, _} = %Robolia.Games.GameRepository{
  repository_url: "https://github.com/Robolia/tic-tac-toe-python",
  language: "python",
  image_url: "https://avatars0.githubusercontent.com/u/1525981?s=200&v=4",
  game_id: game.id
} |> Robolia.Repo.insert()

user = Robolia.Accounts.create_user!(%{
  name: "Robolia",
  github_id: -1,
  avatar_url: "https://avatars3.githubusercontent.com/u/38855042?s=200&v=4"
})

Robolia.Accounts.create_player!(%{
  repository_url: "https://github.com/Robolia/tic-tac-toe-elixir",
  repository_clone_url: "git@github.com:Robolia/tic-tac-toe-elixir.git",
  language: "elixir",
  game_id: game.id,
  user_id: user.id,
  active: true
})
