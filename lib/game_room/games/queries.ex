defmodule GameRoom.Games.Queries do
  import Ecto.Query, only: [from: 2]
  alias GameRoom.Repo

  def for_game(model, %{id: game_id}) do
    from(
      g in model,
      where: g.id == ^game_id
    )
  end

  def count(query) do
    query |> Repo.aggregate(:count, :id)
  end
end
