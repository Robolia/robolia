defmodule Boards.TicTacToeBoard do
  @moduledoc """
  Board logic for TicTacToe game
  """

  defguard allowed_position_number?(value) when is_integer(value) and value >= 1 and value <= 9

  @max_positions 9

  @typedoc "Board position value type"
  @type position_value :: nil | :x | :o

  @typedoc "Board mapping type"
  @type board :: %{
          p1: position_value(),
          p2: position_value(),
          p3: position_value(),
          p4: position_value(),
          p5: position_value(),
          p6: position_value(),
          p7: position_value(),
          p8: position_value(),
          p9: position_value()
        }

  @doc """
  Given a current board map of the game and position number,
  returns `{:ok, true}` if the number is between `1` and `9` and is not a filled position in
  the board, otherwise returns `{:error, :error_message}`.
  """
  @spec valid_position?(board(), integer()) :: {:ok, true} | {:error, atom()}
  def valid_position?(map, position) when allowed_position_number?(position) do
    case position_available?(map, position) do
      true -> {:ok, true}
      false -> {:error, :filled_position}
    end
  end

  def valid_position?(_, _), do: {:error, :position_value_not_allowed}

  @doc """
  Returns `true` if the position is not already filled,
  otherwise return `false`.
  """
  @spec position_available?(board(), integer()) :: boolean()
  def position_available?(map, position) when is_integer(position) do
    map |> Access.get("p#{position}" |> String.to_atom()) |> is_nil
  end

  def position_available?(_, _), do: false

  @doc """
  Returns `true` if one the criteria is true:
  * All 9 positions are filled;
  * One of the players won;
  """
  @spec match_finished?(board()) :: boolean()
  def match_finished?(map) do
    positions_filled(map) >= @max_positions || fetch_winner(map) |> is_nil == false
  end

  @doc """
  Returns `{true, player}` One of the players won;
  Returns `{true, nil}` All 9 positions are filled and no winner;
  Returns `{false, nil}` if have not finished;
  """
  @spec match_finished?(board(), any(), any()) :: {boolean(), any()}
  def match_finished?(map, p1, p2) do
    case fetch_winner(map, p1, p2) do
      nil ->
        if positions_filled(map) >= @max_positions do
          {true, nil}
        else
          {false, nil}
        end

      winner ->
        {true, winner}
    end
  end

  @doc """
  Returns the number of filled positions on the board
  """
  @spec positions_filled(board()) :: integer()
  def positions_filled(map) do
    map
    |> Enum.reduce(0, fn {_, v}, acc ->
      if is_nil(v), do: acc, else: acc + 1
    end)
  end

  @doc """
  Returns next turn number.

  Eg. If 3 positions are filled, next turn is 4.

  If all positions are filled, then returns `nil`.
  """
  @spec next_turn(board()) :: integer() | nil
  def next_turn(map) do
    case map |> positions_filled do
      9 -> nil
      pos_filled -> pos_filled + 1
    end
  end

  @doc """
  Returns the next player or `nil` if there is any possible moviments to make.
  """
  @spec fetch_winner(board(), any(), any()) :: any() | nil
  def fetch_next_player(map, p1, p2) do
    case map |> match_finished? do
      true ->
        nil

      false ->
        if rem(positions_filled(map), 2) == 0 do
          p1
        else
          p2
        end
    end
  end

  @doc """
  Returns the position value for the winner or `nil` if no winner is found
  """
  @spec fetch_winner(board()) :: atom() | nil
  def fetch_winner(map), do: fetch_winner_value(map)

  @doc """
  This function receives the board, anything related to the first player and anything related
  to the second player.

  Returns back the first player if :x is the winner, or the second player if :o is the winner,
  or `nil` if no winner is found.

  First player and Second player could be anything: an atom, a struct, a number...

  Let's suppose:
    iex> first_player = %Player{id: 1}
    iex> second_player = %Player{id: 2}

  Example where the board has first player as winner:
    iex> TicTacToeBoard.fetch_winner(board, first_player, second_player) == first_player

  Example where the board has second player as winner:
    iex> TicTacToeBoard.fetch_winner(board, first_player, second_player) == second_player

  Example where the board has no winner:
    iex> TicTacToeBoard.fetch_winner(board, first_player, second_player) == nil
  """
  @spec fetch_winner(board(), any(), any()) :: any() | nil
  def fetch_winner(map, p1, p2) do
    case fetch_winner_value(map) do
      :x -> p1
      :o -> p2
      _ -> nil
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
