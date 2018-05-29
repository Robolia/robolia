defmodule GameRoom.Competitions.RandomGroupedAllAgainstAllTest do
  use ExUnit.Case
  alias GameRoom.Competitions.RandomGroupedAllAgainstAll, as: Subject

  describe "generate_matches/1" do
    test "returns a list of players to battle against each other when 4 players with 1 groups" do
      players = 1..4 |> Enum.to_list()
      per_group = 4
      expected_matches = 12

      returned_matches = Subject.generate_matches(%{players: players, per_group: per_group})
      all_players_returned = returned_matches |> Enum.flat_map(fn {p1, p2} -> [p1, p2] end)

      players
      |> Enum.each(fn p ->
        assert p in all_players_returned
      end)

      assert length(returned_matches) == expected_matches
      assert all_players_returned |> Enum.uniq() |> length == players |> length
    end

    test "returns a list of players to battle against each other when 4 players with 2 groups" do
      players = 1..4 |> Enum.to_list()
      per_group = 2
      expected_matches = 4

      returned_matches = Subject.generate_matches(%{players: players, per_group: per_group})
      all_players_returned = returned_matches |> Enum.flat_map(fn {p1, p2} -> [p1, p2] end)

      players
      |> Enum.each(fn p ->
        assert p in all_players_returned
      end)

      assert length(returned_matches) == expected_matches
      assert all_players_returned |> Enum.uniq() |> length == players |> length
    end

    test "returns a list of players to battle against each other when 5 players with 2 groups" do
      players = 1..5 |> Enum.to_list()
      per_group = 2
      expected_matches = 8

      returned_matches = Subject.generate_matches(%{players: players, per_group: per_group})
      all_players_returned = returned_matches |> Enum.flat_map(fn {p1, p2} -> [p1, p2] end)

      players
      |> Enum.each(fn p ->
        assert p in all_players_returned
      end)

      assert length(returned_matches) == expected_matches
      assert all_players_returned |> Enum.uniq() |> length == players |> length
    end

    test "returns a list of players to battle against each other when 8 players with 3 groups" do
      players = 1..8 |> Enum.to_list()
      per_group = 3
      expected_matches = 24

      returned_matches = Subject.generate_matches(%{players: players, per_group: per_group})
      all_players_returned = returned_matches |> Enum.flat_map(fn {p1, p2} -> [p1, p2] end)

      players
      |> Enum.each(fn p ->
        assert p in all_players_returned
      end)

      assert length(returned_matches) == expected_matches
      assert all_players_returned |> Enum.uniq() |> length == players |> length
    end

    test "returns a list of players to battle against each other when 21 players with 6 groups" do
      players = 1..21 |> Enum.to_list()
      per_group = 6
      expected_matches = 126

      returned_matches = Subject.generate_matches(%{players: players, per_group: per_group})
      all_players_returned = returned_matches |> Enum.flat_map(fn {p1, p2} -> [p1, p2] end)

      players
      |> Enum.each(fn p ->
        assert p in all_players_returned
      end)

      assert length(returned_matches) == expected_matches
      assert all_players_returned |> Enum.uniq() |> length == players |> length
    end
  end
end
