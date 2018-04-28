defmodule GameRoom.Accounts.Queries do
  import Ecto.Query, only: [from: 2]
  alias GameRoom.Accounts.Player

  def for_game(Player = model, %{game_id: game_id}) do
    from(
      p in model,
      where: p.game_id == ^game_id
    )
  end
end
