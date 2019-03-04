defmodule Competitions.RandomGroupedAllAgainstAll do
  @doc """
  Generate a list of tuples where each tuple has the players that are going to battle
  against each other.

  The players are put in random groups. Which means every time this function
  is called, the players might battle against another opponents.

  If the number of players can't fit in the number of per_group, then the remaining
  players will be distributed equally between other groups. For example, if 8 players are given
  and 3 per_group are asked, the result will be 2 groups with 4 players on each. Another exmple,
  of 7 players are given and 3 per_group are asked, the resilt will be 2 groups with 4 players in
  one group and 3 in another.

  The players can be anything. The function is going to organize them only.

  ### Usage

  iex> players = [player1, player2, player3, player4]
  iex> RandomGroupedAllAgainstAll.generate_matches(%{players: players, per_group: 2})
  [{player1, player2}, {player2, player1}, {player3, player4}, {player4, player3}]

  iex> players = [player1, player2, player3]
  iex> RandomGroupedAllAgainstAll.generate_matches(%{players: players, per_group: 3})
  [{player1, player2}, {player1, player3}, {player2, player1}, {player2, player3}, {player3, player1}, {player3, player2}]

  Note that on the examples above, players are not shuffled. But in practice they will be.
  """
  @spec generate_matches(%{players: list(), per_group: integer()}) :: list(tuple())
  def generate_matches(%{players: players, per_group: per_group}) when is_integer(per_group) do
    %{players: players, per_group: per_group}
    |> generate_groups()
    |> Enum.flat_map(&organize_matches/1)
  end

  defp generate_groups(%{players: players, per_group: per_group}) do
    case players |> Enum.count() <= per_group do
      true ->
        [players]

      false ->
        groups =
          players
          |> Enum.shuffle()
          |> Enum.chunk_every(per_group)

        case Enum.count(groups) > expected_number_of_groups(players, per_group) do
          true ->
            groups
            |> distribute_last_group_between_others(per_group)

          false ->
            groups
        end
    end
  end

  defp organize_matches(players) do
    for p1 <- players,
        p2 <- players,
        p1 != p2,
        do: {p1, p2}
  end

  defp expected_number_of_groups(players, per_group),
    do: (Enum.count(players) / per_group) |> trunc

  defp distribute_last_group_between_others(groups, per_group) do
    last_group = groups |> List.last() |> fill_group_with_nil(per_group)

    groups
    |> Enum.drop(-1)
    |> Enum.zip(last_group)
    |> Enum.map(fn group ->
      (elem(group, 0) ++ [elem(group, 1)]) |> Enum.reject(&is_nil/1)
    end)
  end

  defp fill_group_with_nil(group, per_group),
    do: group ++ List.duplicate(nil, per_group - Enum.count(group))
end
