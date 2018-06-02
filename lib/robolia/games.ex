defmodule Robolia.Games do
  alias Robolia.Games.Game
  alias Robolia.Repo

  def create_game!(%{name: name} = attrs) do
    attrs = attrs |> Enum.into(%{slug: name |> Slugger.slugify_downcase()})

    %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert!()
  end
end
