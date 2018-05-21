defmodule RoboliaRating.Elo do
  alias Elo

  @spec calculate_new_rate(map()) :: tuple
  def calculate_new_rate(%{player_rating: p1, opponent_rating: opp, result: result}) do
    Elo.rate(p1, opp, result)
  end

  @spec initial_rating() :: float
  def initial_rating, do: 1500.0
end
