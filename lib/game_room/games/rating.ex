defmodule GameRoom.Games.Rating do
  alias RoboliaRating.Elo, as: EloRating
  alias GameRoom.Accounts
  alias GameRoom.Accounts.{PlayerRating, Queries}
  alias GameRoom.Repo

  def update_players_rating(%{winner_id: _, first_player_id: p1_id, second_player_id: p2_id} = match) do
    player_rating = PlayerRating
                    |> Queries.for_player(%{id: p1_id})
                    |> Queries.for_game(%{game_id: match.game_id})
                    |> Repo.one()

    opponent_rating = PlayerRating
                      |> Queries.for_player(%{id: p2_id})
                      |> Queries.for_game(%{game_id: match.game_id})
                      |> Repo.one()

    {player_new_rating, opp_new_rating} = EloRating.calculate_new_rate(%{
      player_rating: player_rating.rating,
      opponent_rating: opponent_rating.rating,
      result: match |> fetch_result_for_p1
    })

    Accounts.update_player_rating(player_rating, %{new_rating: player_new_rating})
    Accounts.update_player_rating(opponent_rating, %{new_rating: opp_new_rating})
  end

  defp fetch_result_for_p1(%{winner_id: nil}), do: :draw
  defp fetch_result_for_p1(%{winner_id: winner_id, first_player_id: winner_id}), do: :win
  defp fetch_result_for_p1(_), do: :loss
end
