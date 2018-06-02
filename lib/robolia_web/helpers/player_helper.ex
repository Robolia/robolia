defmodule RoboliaWeb.Helpers.PlayerHelper do
  alias Robolia.Accounts

  def fetch_rating(player),
    do: player.rating.rating |> :erlang.float_to_binary([:compact, decimals: 2])

  def current_rank_position(player), do: player |> Accounts.current_rank() |> get_in([:position])
end
