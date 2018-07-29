defmodule Robolia.DataTest do
  use ExUnit.Case
  import Robolia.Data

  setup do
    expected =
      """
      {"p1": "x", "p2": "o", "p3": None}
      """
      |> String.trim()

    {:ok, expected: expected}
  end

  describe "into_python_repr/1 when given map with key and value as atom" do
    setup do
      {:ok, map: %{p1: :x, p2: :o, p3: nil}}
    end

    test "returns a python dict as string", %{map: map, expected: expected} do
      assert into_python_repr(map) == expected
    end
  end

  describe "into_python_repr/1 when given map with key as atom" do
    setup do
      {:ok, map: %{p1: "x", p2: "o", p3: nil}}
    end

    test "returns a python dict as string", %{map: map, expected: expected} do
      assert into_python_repr(map) == expected
    end
  end

  describe "into_python_repr/1 when given map with key and value as string" do
    setup do
      {:ok, map: %{"p1" => "x", "p2" => "o", "p3" => nil}}
    end

    test "returns a python dict as string", %{map: map, expected: expected} do
      assert into_python_repr(map) == expected
    end
  end
end
