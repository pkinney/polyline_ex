defmodule PolylineBench do
  use Benchfella

  @medium_polyline "i|~wAeo{aVw@i@SI]EkN^c@@KfXGNULcCo@}HgByEkAcFcAsCk@oAYeAYgZuGiBu@wCi@iGo@eKBiHx@aGzAeMpEgJ`Dy@wC~@kK|D_A`@yLlEkAXuJhDuAj@yAp@mKzD{h@bRu@NcIpCmIbDmGxBk@RkD`AgBj@wAf@a@mBe@sCiCiNkCcMgCkMeBZWE}@BmKsAkCWwE]{BGyC?iBD}BJwCVgDb@mByNu@wSGaC{DL"
  @medium_linestring @medium_polyline |> Polyline.decode()

  @long_polyline Path.join([".", "test", "fixtures", "long.polyline.txt"])
                 |> File.read!()
                 |> String.trim()

  @long_linestring Path.join([".", "test", "fixtures", "long.geo.json"])
                   |> File.read!()
                   |> String.trim()
                   |> Poison.decode!()
                   |> Geo.JSON.decode!()
                   |> Map.get(:coordinates)

  bench "decode small polyline" do
    "_p~iF~ps|U_ulLnnqC_mqNvxq`@" |> Polyline.decode()
  end

  bench "decode medium polyline" do
    "i|~wAeo{aVw@i@SI]EkN^c@@KfXGNULcCo@}HgByEkAcFcAsCk@oAYeAYgZuGiBu@wCi@iGo@eKBiHx@aGzAeMpEgJ`Dy@wC~@kK|D_A`@yLlEkAXuJhDuAj@yAp@mKzD{h@bRu@NcIpCmIbDmGxBk@RkD`AgBj@wAf@a@mBe@sCiCiNkCcMgCkMeBZWE}@BmKsAkCWwE]{BGyC?iBD}BJwCVgDb@mByNu@wSGaC{DL"
    |> Polyline.decode()
  end

  bench "decode a large polyline" do
    @long_polyline |> Polyline.decode()
  end

  bench "encode a small linestring" do
    [{-120.2, 38.5}, {-120.95, 40.7}, {-126.453, 43.252}] |> Polyline.encode()
  end

  bench "encode a medium linestring" do
    @medium_linestring |> Polyline.encode()
  end

  bench "encode a large linestirng" do
    @long_linestring |> Polyline.encode()
  end
end
