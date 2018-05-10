defmodule GameRoomWeb.PlayersView do
  use GameRoomWeb, :view
  alias GameRoomWeb.Language

  def languages("tic-tac-toe") do
    [
      %Language{
        name: "Elixir",
        slug: "elixir",
        repository_url: "https://github.com/Robolia/tic-tac-toe-elixir-example",
        image_url: "https://avatars0.githubusercontent.com/u/1481354"
      }
    ]
  end

  def languages(_), do: []
end
