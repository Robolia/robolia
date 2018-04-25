defmodule GameRoom.Games.TicTacToes.Competition do
  def generate_groups(%{players: players, per_group: per_group}) when is_integer(per_group) do
    groups = players
    |> Enum.shuffle
    |> Enum.chunk_every(per_group)

    case Enum.count(groups) > expected_number_of_groups(players, per_group) do
      true ->
        groups
        |> distribute_last_group_between_others(per_group)
      false ->
        groups
    end
  end

  defp expected_number_of_groups(players, per_group), do:
    Enum.count(players) / per_group |> trunc

  defp distribute_last_group_between_others(groups, per_group) do
    last_group = groups |> List.last |> fill_group_with_nil(per_group)

    Enum.drop(groups, -1)
    |> Enum.zip(last_group)
    |> Enum.map(fn group ->
      elem(group, 0) ++ [elem(group, 1)] |> Enum.reject(&is_nil/1)
    end)
  end

  def fill_group_with_nil(group, per_group), do:
    group ++ List.duplicate(nil, per_group - Enum.count(group))
end
