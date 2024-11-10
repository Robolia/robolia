defmodule RoboliaWeb.MovimentSerializer do
  @moduledoc false

  def serialize(moviment) do
    Map.take(moviment, [:position, :turn, :valid, :details])
  end
end
