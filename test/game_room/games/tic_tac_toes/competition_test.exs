defmodule GameRoom.Games.TicTacToes.CompetitionTest do
  use GameRoom.DataCase
  alias GameRoom.Games.TicTacToes.Competition

  describe "generate_groups/1" do
    test "when 2 players with 1 per group are given then returns 2 groups" do
      data = %{players: [1, 2], per_group: 1}
      expected_groups = 2

      result = Competition.generate_groups(data)

      assert length(result) == expected_groups
      result |> Enum.each(fn group ->
        assert length(group) == data[:per_group]
      end)
    end

    test "when 4 players with 2 per group are given then returns 2 groups" do
      data = %{players: (1..4), per_group: 2}
      expected_groups = 2

      result = Competition.generate_groups(data)

      assert length(result) == expected_groups
      result |> Enum.each(fn group ->
        assert length(group) == data[:per_group]
      end)
    end

    test "when 10 players with 3 per group are given then returns 3 groups being one with 4 players" do
      data = %{players: (1..10), per_group: 3}
      expected_groups = 3

      result = Competition.generate_groups(data)
      num_of_players = result |> Enum.reduce(0, fn s, acc -> acc + Enum.count(s) end)

      assert length(result) == expected_groups
      assert num_of_players == data[:players] |> Enum.count
      result |> Enum.each(fn group ->
        assert length(group) in [data[:per_group], data[:per_group] + 1]
      end)
    end

    test "when 11 players with 3 per group are given then returns 3 groups being two with 4 players" do
      data = %{players: (1..11), per_group: 3}
      expected_groups = 3

      result = Competition.generate_groups(data)
      num_of_players = result |> Enum.reduce(0, fn s, acc -> acc + Enum.count(s) end)

      assert length(result) == expected_groups
      assert num_of_players == data[:players] |> Enum.count
      result |> Enum.each(fn group ->
        assert length(group) in [data[:per_group], data[:per_group] + 1]
      end)
    end

    test "when 12 players with 3 per group are given then returns 4 groups" do
      data = %{players: (1..12), per_group: 3}
      expected_groups = 4

      result = Competition.generate_groups(data)
      num_of_players = result |> Enum.reduce(0, fn s, acc -> acc + Enum.count(s) end)

      assert length(result) == expected_groups
      assert num_of_players == data[:players] |> Enum.count
      result |> Enum.each(fn group ->
        assert length(group) in [data[:per_group], data[:per_group] + 1]
      end)
    end
  end
end
