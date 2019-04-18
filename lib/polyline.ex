defmodule Polyline do
  @moduledoc ~S"""
  Encode and decode Polylines to and from List of `{lon, lat}` tuples.

  The encode functions accept a `precision` parameter that defines the
  number of significant digits to retain when encoding.  The same precision
  must be supplied to the decode or the resulting linestring will be incorrect.
  The default is `5`, which correlates to approximately 1 meter of precision.

  ## Examples
      iex> Polyline.encode([{-120.2, 38.5}, {-120.95, 40.7}, {-126.453, 43.252}])
      "_p~iF~ps|U_ulLnnqC_mqNvxq`@"

      iex> Polyline.decode("_p~iF~ps|U_ulLnnqC_mqNvxq`@")
      [{-120.2, 38.5}, {-120.95, 40.7}, {-126.453, 43.252}]
  """

  @default_precision 5

  use Bitwise, only_operators: true

  @doc ~S"""
  Encode a List of coordinate tuples into a Polyline String. Also works with
  `Geo.LineString` structs (see https://hex.pm/packages/geo).

  ## Examples
      iex> Polyline.encode([{-120.2, 38.5}, {-120.95, 40.7}, {-126.453, 43.252}])
      "_p~iF~ps|U_ulLnnqC_mqNvxq`@"

      iex> Polyline.encode([{-120.2, 38.5}, {-120.95, 40.7}, {-126.453, 43.252}], 6)
      "_izlhA~rlgdF_{geC~ywl@_kwzCn`{nI"

      iex> "LINESTRING(-120.2 38.5, -120.95 40.7, -126.453 43.252)"
      ...> |> Geo.WKT.decode!
      ...> |> Map.get(:coordinates)
      ...> |> Polyline.encode
      "_p~iF~ps|U_ulLnnqC_mqNvxq`@"
  """
  def encode(coordinates, precision \\ @default_precision) do
    factor = :math.pow(10, precision)

    rounded_coordinates =
      Enum.map(coordinates, fn {x, y} ->
        {round(x * factor), round(y * factor)}
      end)

    elem(do_encode(rounded_coordinates), 0)
  end

  defp do_encode([]), do: {"", nil}

  defp do_encode([{x0, y0} | coordinates]) do
    Enum.reduce(coordinates, encode_step({x0, y0}, {"", {0, 0}}), fn t, acc ->
      encode_step(t, acc)
    end)
  end

  defp encode_step({x, y}, {acc, {x_prev, y_prev}}) do
    {acc <> encode_int(y - y_prev) <> encode_int(x - x_prev), {x, y}}
  end

  defp encode_int(x) do
    x <<< 1
    |> unsign
    |> collect_chars
    |> to_string
  end

  defp collect_chars(c) when c < 0x20, do: [c + 63]
  defp collect_chars(c), do: [(0x20 ||| (c &&& 0x1F)) + 63 | collect_chars(c >>> 5)]

  @doc ~S"""
  Decode a polyline String into a List of `{lon, lat}` tuples.

  ## Examples
      iex> Polyline.decode("_p~iF~ps|U_ulLnnqC_mqNvxq`@")
      [{-120.2, 38.5}, {-120.95, 40.7}, {-126.453, 43.252}]

      iex> Polyline.decode("_izlhA~rlgdF_{geC~ywl@_kwzCn`{nI", 6)
      [{-120.2, 38.5}, {-120.95, 40.7}, {-126.453, 43.252}]
  """
  def decode(str, precision \\ @default_precision)
  def decode(str, _) when str == "", do: []

  def decode(str, precision) do
    factor = :math.pow(10, precision)
    chars = String.to_charlist(str)

    terms =
      Enum.reduce_while(chars, {[], chars}, fn
        _, {values, ''} ->
          {:halt, values}

        _, {values, remain} ->
          {next_one, remain} = decode_next(remain, 0)
          {:cont, {values ++ [sign(next_one) / factor], remain}}
      end)

    Enum.reduce(Enum.chunk_every(terms, 2, 2, :discard), nil, fn
      [y, x], nil -> [{x, y}]
      [y, x], acc -> acc ++ [Vector.add({x, y}, List.last(acc))]
    end)
  end

  defp decode_next([head | []], shift), do: {decode_char(head, shift), ''}
  defp decode_next([head | tail], shift) when head < 95, do: {decode_char(head, shift), tail}

  defp decode_next([head | tail], shift) do
    {next, remain} = decode_next(tail, shift + 5)
    {decode_char(head, shift) ||| next, remain}
  end

  defp decode_char(char, shift), do: (char - 63 &&& 0x1F) <<< shift

  defp unsign(x) when x < 0, do: -(x + 1)
  defp unsign(x), do: x
  defp sign(result) when (result &&& 1) === 1, do: -((result >>> 1) + 1)
  defp sign(result), do: result >>> 1
end
