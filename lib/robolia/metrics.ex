defmodule Robolia.Metrics do
  @moduledoc """
  Encapsulation module for sending metrics to the metrics aggregator.

  All metrics are prefixed with "robolia." by default.
  """

  require DogStatsd

  @doc "Increment the counter for a given metric"
  @spec increment(String.t) :: any()
  def increment(metric), do: connection() |> DogStatsd.increment("#{metric_prefix()}.#{metric}")

  defp connection do
    {:ok, statsd} = DogStatsd.new("localhost", 8125)
    statsd
  end

  defp statsd_server, do: "localhost"

  defp statsd_port, do: 8125

  defp metric_prefix, do: "robolia"
end
