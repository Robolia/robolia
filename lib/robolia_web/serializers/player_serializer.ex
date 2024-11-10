defmodule RoboliaWeb.PlayerSerializer do
  @moduledoc false
  alias Robolia.Repo

  def serialize(nil), do: %{}

  def serialize(player) do
    player = Repo.preload(player, [:user, :rating])

    %{
      name: player.user.name,
      rating: :erlang.float_to_binary(player.rating.rating, [:compact, decimals: 2])
    }
  end
end
