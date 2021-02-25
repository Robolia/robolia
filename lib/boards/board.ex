defmodule Boards.Board do
  @moduledoc """
  Defines the behaviour of a Board
  """
  @type board() :: any()

  @callback valid_position?(board(), integer()) :: {:ok, true} | {:error, atom()}
  @callback position_available?(board(), integer()) :: boolean()
  @callback match_finished?(board()) :: boolean()
  @callback match_finished?(board(), any(), any()) :: {boolean(), any()}
  @callback positions_filled(board()) :: integer()
  @callback next_turn(board()) :: integer() | nil
  @callback fetch_next_player(board(), any(), any()) :: any() | nil
  @callback fetch_winner(board(), any(), any()) :: any() | nil
  @callback fetch_winner(board()) :: atom() | nil
  @callback fetch_winner(board(), any(), any()) :: any() | nil
end
