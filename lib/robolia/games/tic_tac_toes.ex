defmodule Robolia.Games.TicTacToes do
  alias Boards.TicTacToeBoard
  alias Robolia.Games.TicTacToes.{TicTacToeMatch, TicTacToeMoviment, Queries}
  alias Robolia.{GameError, Repo}

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
    e in Ecto.InvalidChangesetError -> error(e, __STACKTRACE__)
  end

  def update_match!(%TicTacToeMatch{} = match, attrs) do
    match
    |> Ecto.Changeset.change(attrs)
    |> Repo.update!()
  end

  def add_moviment!(%TicTacToeMatch{id: match_id} = match, %{position: position} = attrs) do
    unless player_playing?(match, attrs),
      do: raise(GameError, message: "Given player is not playing this match")

    case match |> current_state |> TicTacToeBoard.valid_position?(position) do
      {:ok, true} ->
        moviment =
          %TicTacToeMoviment{}
          |> TicTacToeMoviment.changeset(Map.merge(attrs, %{tic_tac_toe_match_id: match_id}))
          |> Repo.insert!()

        case match_finished?(match) do
          {true, nil} ->
            match |> update_match!(%{next_player_id: nil, status: TicTacToeMatch.draw()})

          {true, winner_id} ->
            match
            |> update_match!(%{
              next_player_id: nil,
              winner_id: winner_id,
              status: TicTacToeMatch.winner()
            })

          {false, _} ->
            next_player_id =
              match
              |> current_state
              |> TicTacToeBoard.fetch_next_player(match.first_player_id, match.second_player_id)

            match |> update_match!(%{next_player_id: next_player_id})
        end

        moviment

      {:error, detail} ->
        moviment =
          %TicTacToeMoviment{}
          |> TicTacToeMoviment.changeset(
            Map.merge(attrs, %{
              tic_tac_toe_match_id: match_id,
              valid: false,
              details: detail |> to_string
            })
          )
          |> Repo.insert!()

        winner_id =
          match
          |> current_state
          |> TicTacToeBoard.fetch_next_player(match.first_player_id, match.second_player_id)

        match
        |> update_match!(%{
          next_player_id: nil,
          winner_id: winner_id,
          status: TicTacToeMatch.winner()
        })

        moviment
    end
  rescue
    e in Ecto.InvalidChangesetError -> error(e, __STACKTRACE__)
    e in Ecto.ConstraintError -> error(e, __STACKTRACE__)
  end

  def current_state(%TicTacToeMatch{} = match) do
    match = Repo.preload(match, :moviments)

    match.moviments
    |> Enum.map(fn %{player_id: player_id} = mov ->
      mark = if player_id == match.first_player_id, do: :x, else: :o

      {String.to_atom("p#{mov.position}"), mark}
    end)
    |> Map.new()
    |> Enum.into(%{ # TODO: fetch this initial state from the Board
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

  def match_finished?(%TicTacToeMatch{winner_id: nil} = match) do
    match
    |> current_state
    |> TicTacToeBoard.match_finished?(match.first_player_id, match.second_player_id)
  end

  def match_finished?(%TicTacToeMatch{winner_id: winner_id}) do
    {true, winner_id}
  end

  defp player_playing?(%TicTacToeMatch{} = match, %{player_id: player_id}) do
    import Robolia.Games.TicTacToes.Queries, only: [for_match: 2, for_player: 2, count: 1]

    TicTacToeMatch
    |> for_match(%{id: match.id})
    |> for_player(%{id: player_id})
    |> count() > 0
  end

  defp error(exception, stacktrace) do
    reraise GameError, [exception: exception], stacktrace
  end
end
