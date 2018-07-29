defmodule Robolia.Data do
  @moduledoc "Data manipulation"

  @doc "Recursively stringify all the keys and values of a map"
  @spec stringify_all(map()) :: map()
  def stringify_all(map) when is_map(map) do
    for {k, v} <- map, into: %{} do
      case {is_bitstring(k), is_bitstring(v)} do
        {false, false} ->
          {to_string(k), stringify_all(v)}

        {true, false} ->
          {k, stringify_all(v)}

        {false, true} ->
          {to_string(k), v}

        {true, true} ->
          {k, v}
      end
    end
  end

  def stringify_all([h | t]), do: [stringify_all(h) | stringify_all(t)]
  def stringify_all(term) when is_atom(term), do: to_string(term)
  def stringify_all(term), do: term

  @doc "Convert given map to the Python representation of it in String"
  @spec into_python_repr(map()) :: String.t()
  def into_python_repr(map) when is_map(map) do
    map = stringify_all(map)

    "#{inspect(map)}"
    |> String.replace("\"\"", "None")
    |> String.replace("%", "")
    |> String.replace(" =>", ":")
  end
end
