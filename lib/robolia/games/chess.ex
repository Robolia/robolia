defmodule Robolia.Games.Chess do
  alias Boards.ChessBoard
  alias Robolia.Games.Chess.{ChessMatch}
  alias Robolia.{GameError, Repo}

  def create_match!(attrs) do
    %ChessMatch{}
    |> ChessMatch.changeset(attrs)
    |> Repo.insert!()
  rescue
    e in Ecto.InvalidChangesetError -> error(e, __STACKTRACE__)
  end

  def match_finished?(%ChessMatch{winner_id: nil} = match) do
    match
    |> movements # TODO passar os movimentos para a funcao abaixo, e ela gera o FEN para responder
    |> ChessBoard.match_finished?(match.first_player_id, match.second_player_id)
  end

  def match_finished?(%ChessMatch{winner_id: winner_id}) do
    {true, winner_id}
  end

  def current_state(%ChessMatch{} = match) do
    "" # TODO: FEN
  end

  defp error(exception, stacktrace) do
    reraise GameError, [exception: exception], stacktrace
  end
end
