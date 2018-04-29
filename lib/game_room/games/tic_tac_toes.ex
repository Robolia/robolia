defmodule GameRoom.Games.TicTacToes do
  alias GameRoom.Games.TicTacToes.{TicTacToeMatch, TicTacToeMoviment, Match, Queries}
  alias GameRoom.{GameError, Repo}
  import Ecto.Query, only: [from: 2]

  def refresh(%TicTacToeMatch{} = match) do
    TicTacToeMatch
    |> Queries.for_match(%{id: match.id})
    |> Repo.one!()
  end

  def create_match!(attrs) do
    %TicTacToeMatch{}
    |> TicTacToeMatch.changeset(attrs)
    |> Repo.insert!()
  rescue
    e in Ecto.InvalidChangesetError -> error(e)
  end

  def add_moviment!(%TicTacToeMatch{id: match_id} = match, %{position: position} = attrs) do
    unless valid_position_number?(position),
      do: raise(GameError, message: "Position #{position} is invalid for this match")

    unless match |> player_playing?(attrs),
      do: raise(GameError, message: "Given player is not playing this match")

    moviment =
      %TicTacToeMoviment{}
      |> TicTacToeMoviment.changeset(Map.merge(attrs, %{tic_tac_toe_match_id: match_id}))
      |> Repo.insert!()

    case match_finished?(match) do
      {true, %{winner: nil}} ->
        match |> update_match!(%{next_player_id: nil})

      {true, %{winner: winner}} ->
        match |> update_match!(%{next_player_id: nil, winner_id: winner.id})

      {false, _} ->
        match |> update_next_player!
    end

    moviment
  rescue
    e in Ecto.InvalidChangesetError -> error(e)
    e in Ecto.ConstraintError -> error(e)
  end

  def match_finished?(%TicTacToeMatch{winner_id: winner_id} = match)
      when is_nil(winner_id) == false do
    match = match |> Repo.preload([:winner])
    {true, %{winner: match.winner}}
  end

  def match_finished?(%TicTacToeMatch{} = match) do
    case Match.calculate_winner(match) do
      {:ok, winner} ->
        {true, %{winner: winner}}

      {:error, _} ->
        match = match |> Repo.preload([:moviments])

        if match.moviments |> Enum.count() >= 9 do
          {true, %{winner: nil}}
        else
          {false, %{winner: nil}}
        end
    end
  end

  def next_turn(%TicTacToeMatch{} = match) do
    match = match |> Repo.preload(:moviments)

    case match.moviments |> Enum.count() do
      num_moviments when num_moviments < 9 ->
        num_moviments + 1

      _ ->
        nil
    end
  end

  def current_state(%TicTacToeMatch{} = match) do
    match =
      match |> Repo.preload(moviments: from(m in TicTacToeMoviment, order_by: m.inserted_at))

    match.moviments
    |> Enum.map(fn %{player_id: player_id} = mov ->
      mark = if player_id == match.first_player_id, do: :x, else: :o

      {String.to_atom("p#{mov.position}"), mark}
    end)
    |> Map.new()
    |> Enum.into(%{
      p1: nil,
      p2: nil,
      p3: nil,
      p4: nil,
      p5: nil,
      p6: nil,
      p7: nil,
      p8: nil,
      p9: nil
    })
  end

  def update_match!(%TicTacToeMatch{} = match, attrs) do
    Ecto.Changeset.change(match, attrs)
    |> Repo.update!()
  end

  defp player_playing?(%TicTacToeMatch{} = match, %{player_id: player_id}) do
    import GameRoom.Games.TicTacToes.Queries, only: [for_match: 2, for_player: 2, count: 1]

    TicTacToeMatch
    |> for_match(%{id: match.id})
    |> for_player(%{id: player_id})
    |> count() > 0
  end

  defp valid_position_number?(position_number) do
    position_number >= 1 && position_number <= 9
  end

  defp update_next_player!(%TicTacToeMatch{} = match) do
    next_player_id =
      if match.next_player_id == match.first_player_id do
        match.second_player_id
      else
        match.first_player_id
      end

    match |> update_match!(%{next_player_id: next_player_id})
  end

  defp error(exception) do
    reraise GameError, [exception: exception], System.stacktrace()
  end
end
