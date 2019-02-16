defmodule RoboliaWeb.MatchChannel do
  @moduledoc false
  use Phoenix.Channel

  alias Robolia.Games.TicTacToes.{Queries, TicTacToeMoviment, TicTacToeMatch}
  alias Robolia.Repo
  alias RoboliaWeb.{MatchSerializer, MovimentSerializer}

  def join("match:tic-tac-toe:" <> _match_id, _payload, socket) do
    send(self(), "feed_match")
    {:ok, socket}
  end

  def handle_info("feed_match", %{topic: "match:tic-tac-toe:" <> match_id} = socket) do
    match = Repo.get(TicTacToeMatch, match_id)

    moviments =
      TicTacToeMoviment
      |> Queries.for_match(match, %{ordered: :turn})
      |> Repo.all()

    push(
      socket,
      "feed_match",
      %{
        moviments: Enum.map(moviments, &MovimentSerializer.serialize/1),
        match: MatchSerializer.serialize(match)
      }
    )
    {:noreply, socket}
  end
end
