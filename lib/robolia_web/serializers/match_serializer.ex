defmodule RoboliaWeb.MatchSerializer do
  @moduledoc false

  alias Robolia.Repo
  alias RoboliaWeb.PlayerSerializer

  def serialize(match) do
    match = Repo.preload(match, [:first_player, :second_player, :next_player, :winner])

    %{
      first_player: PlayerSerializer.serialize(match.first_player),
      second_player: PlayerSerializer.serialize(match.second_player),
      next_player: PlayerSerializer.serialize(match.next_player),
      winner: PlayerSerializer.serialize(match.winner),
      status: label_for(match.status),
      finished_at: match.finished_at
    }
  end

  defp label_for(0), do: "ongoing"
  defp label_for(1), do: "draw"
  defp label_for(2), do: "finished"
end
