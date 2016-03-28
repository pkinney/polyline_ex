defmodule PolylineTest do
  use ExUnit.Case
  doctest Polyline
    use Bitwise, only_operators: true

  @example [{-120.2, 38.5}, {-120.95, 40.7}, {-126.453, 43.252}]
  @example_slashes [{-82.55, 35.6}, {-82.55015, 35.59985}, {-82.55, 35.6}]

  test "encode an empty List" do
    assert Polyline.encode([]) == ""
  end

  test "encode a single location" do
    assert Polyline.encode([{-120.2, 38.5}]) == "_p~iF~ps|U"
  end

  test "encode a List of lon/lat pairs into an String" do
    assert Polyline.encode(@example) == "_p~iF~ps|U_ulLnnqC_mqNvxq`@"
  end

  test "encode a List of lon/lat pairs into an String with custom precision" do
    assert Polyline.encode(@example, 6) == "_izlhA~rlgdF_{geC~ywl@_kwzCn`{nI"
  end

  test "decode an empty List" do
    assert Polyline.decode("") == []
  end

  test "decode a single location" do
    assert Polyline.decode("_p~iF~ps|U") == [{-120.2, 38.5}]
  end

  test "decode a String into a List of lon/lat pairs" do
    assert Polyline.decode("_p~iF~ps|U_ulLnnqC_mqNvxq`@") == @example
  end

  test "decode a String into a List of lon/lat pairs with custom precision" do
    assert Polyline.decode("_izlhA~rlgdF_{geC~ywl@_kwzCn`{nI", 6) == @example
  end

  test "encode -> decode" do
    assert (@example_slashes |> Polyline.encode |> Polyline.decode) == @example_slashes
  end

  test "decode -> encode" do
    assert ("_chxEn`zvN\\\\]]" |> Polyline.decode |> Polyline.encode) == "_chxEn`zvN\\\\]]"
  end

  test "decode a long string to Geometry" do
    res =
      Path.join([".", "test", "fixtures", "long.polyline.txt"])
      |> File.read!
      |> String.strip
      |> Polyline.decode

    expected =
      Path.join([".", "test", "fixtures", "long.geo.json"])
      |> File.read!
      |> String.strip

    assert %Geo.LineString{coordinates: res} |> Geo.JSON.encode |> Poison.encode! == expected
  end

  test "encode a long string" do
    res =
      Path.join([".", "test", "fixtures", "long.geo.json"])
      |> File.read!
      |> Poison.decode!
      |> Geo.JSON.decode
      |> Map.get(:coordinates)
      |> Polyline.encode

    expected =
      Path.join([".", "test", "fixtures", "long.polyline.txt"])
      |> File.read!
      |> String.strip

    assert res == expected
  end

  test "identity with a long string to Geometry" do
    polyline =
      Path.join([".", "test", "fixtures", "long.polyline.txt"])
      |> File.read!
      |> String.strip

    assert (polyline |> Polyline.decode |> Polyline.encode) == polyline
  end
end
