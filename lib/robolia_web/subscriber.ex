defmodule RoboliaWeb.Subscriber do
  @moduledoc false
  use GenServer

  alias Phoenix.PubSub
  alias Robolia.Games.TicTacToes.{Queries, TicTacToeMoviment}
  alias Robolia.Repo
  alias RoboliaWeb.{MatchSerializer, MovimentSerializer}

  @name __MODULE__
  @moviment_created_event "moviment_created"
  @match_finished_event "match_finished"

  def start_link, do: start_link(%{name: @name})

  def start_link(%{name: name}) do
    {:ok, _server} = GenServer.start_link(@name, nil, name: name)
  end

  def init(opts) do
    PubSub.subscribe(Robolia.PubSub, @moviment_created_event)
    PubSub.subscribe(Robolia.PubSub, @match_finished_event)

    {:ok, opts}
  end

  def handle_info(%{event: @moviment_created_event, match: match}, state) do
    moviments =
      TicTacToeMoviment
      |> Queries.for_match(match, %{ordered: :turn})
      |> Repo.all()

    RoboliaWeb.Endpoint.broadcast!(
      "match:tic-tac-toe:#{match.id}",
      "feed_moviments",
      %{moviments: Enum.map(moviments, &MovimentSerializer.serialize/1)}
    )

    {:noreply, state}
  end

  def handle_info(%{event: @match_finished_event, match: match}, state) do
    moviments =
      TicTacToeMoviment
      |> Queries.for_match(match, %{ordered: :turn})
      |> Repo.all()

    RoboliaWeb.Endpoint.broadcast!(
      "match:tic-tac-toe:#{match.id}",
      "feed_match",
      %{
        moviments: Enum.map(moviments, &MovimentSerializer.serialize/1),
        match: MatchSerializer.serialize(match)
      }
    )

    {:noreply, state}
  end
end
