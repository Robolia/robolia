defmodule Robolia.Games do
  alias Robolia.Games.Game
  alias Robolia.Repo

  def create_game!(%{name: name} = attrs) do
    attrs = Enum.into(attrs, %{slug: Slugger.slugify_downcase(name)})

    %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert!()
  end
end
