defmodule GameRoom.Games.TicTacToes.Match.Winner do
  def calculate(%{
        current_state: current_state,
        first_player: first_player,
        second_player: second_player
      }) do
    case fetch_winner_value(current_state) do
      :x ->
        first_player

      :o ->
        second_player

      _ ->
        nil
    end
  end

  defp fetch_winner_value(%{p1: :x, p2: :x, p3: :x}), do: :x
  defp fetch_winner_value(%{p4: :x, p5: :x, p6: :x}), do: :x
  defp fetch_winner_value(%{p7: :x, p8: :x, p9: :x}), do: :x
  defp fetch_winner_value(%{p1: :x, p4: :x, p7: :x}), do: :x
  defp fetch_winner_value(%{p2: :x, p5: :x, p8: :x}), do: :x
  defp fetch_winner_value(%{p3: :x, p6: :x, p9: :x}), do: :x
  defp fetch_winner_value(%{p1: :x, p5: :x, p9: :x}), do: :x
  defp fetch_winner_value(%{p3: :x, p5: :x, p7: :x}), do: :x

  defp fetch_winner_value(%{p1: :o, p2: :o, p3: :o}), do: :o
  defp fetch_winner_value(%{p4: :o, p5: :o, p6: :o}), do: :o
  defp fetch_winner_value(%{p7: :o, p8: :o, p9: :o}), do: :o
  defp fetch_winner_value(%{p1: :o, p4: :o, p7: :o}), do: :o
  defp fetch_winner_value(%{p2: :o, p5: :o, p8: :o}), do: :o
  defp fetch_winner_value(%{p3: :o, p6: :o, p9: :o}), do: :o
  defp fetch_winner_value(%{p1: :o, p5: :o, p9: :o}), do: :o
  defp fetch_winner_value(%{p3: :o, p5: :o, p7: :o}), do: :o

  defp fetch_winner_value(_), do: nil
end
