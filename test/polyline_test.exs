defmodule PolylineTest do
  use ExUnit.Case
  use ExUnitProperties
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
    assert @example_slashes |> Polyline.encode() |> Polyline.decode() == @example_slashes
  end

  test "decode -> encode" do
    assert "_chxEn`zvN\\\\]]" |> Polyline.decode() |> Polyline.encode() == "_chxEn`zvN\\\\]]"
  end

  test "decode a long string to Geometry" do
    res =
      Path.join([".", "test", "fixtures", "long.polyline.txt"])
      |> File.read!()
      |> String.trim()
      |> Polyline.decode()

    expected =
      Path.join([".", "test", "fixtures", "long.geo.json"])
      |> File.read!()
      |> String.trim()

    assert %Geo.LineString{coordinates: res} |> Geo.JSON.encode!() |> Poison.encode!() == expected
  end

  test "encode an over-precise string same way as reference implementation" do
    # reference value is generated using following JS google maps API code:
    # raw_coords = [[-87.650934, 41.875332], [-87.650938, 41.875336], [-87.650941, 41.87534]]
    # path = raw_coords.map(function(coords){ return new google.maps.LatLng(coords[1], coords[0]) })
    # google.maps.geometry.encoding.encodePath(path)
    assert Polyline.encode([
             {-87.650933, 41.875332},
             {-87.650936, 41.875336},
             {-87.650942, 41.875340}
           ]) == "ywq~Fhi~uOA@??"
  end

  test "encode a long string" do
    res =
      Path.join([".", "test", "fixtures", "long.geo.json"])
      |> File.read!()
      |> Poison.decode!()
      |> Geo.JSON.decode!()
      |> Map.get(:coordinates)
      |> Polyline.encode()

    expected =
      Path.join([".", "test", "fixtures", "long.polyline.txt"])
      |> File.read!()
      |> String.trim()

    assert res == expected
  end

  test "identity with a long string to Geometry" do
    polyline =
      Path.join([".", "test", "fixtures", "long.polyline.txt"])
      |> File.read!()
      |> String.trim()

    assert polyline |> Polyline.decode() |> Polyline.encode() == polyline
  end

  test "identity with 0,0 point" do
    polyline = "??"

    assert polyline |> Polyline.decode() |> Polyline.encode() == polyline
  end

  test "discard leftover elements when decoding" do
    string =
      "i|~wAeo{aVw@i@SI]EkN^c@@KfXGNULcCo@}HgByEkAcFcAsCk@oAYeAYgZuGiBu@wCi@iGo@eKBiHx@aGzAeMpEgJ`Dy@wC~@kK|D_A`@yLlEkAXuJhDuAj@yAp@mKzD{h@bRu@NcIpCmIbDmGxBk@RkD`AgBj@wAf@a@mBe@sCiCiNkCcMgCkMeBZWE}@BmKsAkCWwE]{BGyC?iBD}BJwCVgDb@mByNu@wSGaC{DL"

    assert string |> Polyline.decode() |> Enum.count() == 64
  end

  property "encoding/decoding returns approximately the same points" do
    check all(points <- point_list()) do
      encoded = Polyline.encode(points)
      decoded = Polyline.decode(encoded)
      assert length(decoded) == length(points)

      for {expected, actual} <- Enum.zip(points, decoded) do
        assert_approx_equal_points(expected, actual)
      end
    end
  end

  defp coord, do: float(min: -180.0, max: 180.0)
  defp point, do: tuple({coord(), coord()})
  defp point_list, do: nonempty(list_of(point(), max_length: 10))

  defp assert_approx_equal_points({expected_lon, expected_lat}, {actual_lon, actual_lat}) do
    assert_in_delta expected_lon, actual_lon, 0.00001
    assert_in_delta expected_lat, actual_lat, 0.00001
  end
end
