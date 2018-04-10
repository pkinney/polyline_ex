# Polyline Encode/Decode for Elixir

[![Build Status](https://travis-ci.org/pkinney/polyline_ex.svg?branch=master)](https://travis-ci.org/pkinney/polyline_ex)
[![Hex.pm](https://img.shields.io/hexpm/v/polyline.svg)](https://hex.pm/packages/polyline)

This is an Elixir implementation of [polyline](https://developers.google.com/maps/documentation/utilities/polylinealgorithm)
encoding/decoding.  Functions are provided to convert a List of `{lon, lat}`
tuples to a String polyline representation and back.

**Note**: while a lot of libraries use `[latitude, longitude]` ordering, this
library maintains proper cartesian order (`{x, y}` or `{longitude, latitude}`)
in order to be more interoperable with common formats such as GeoJSON and WKT.


## Installation

```elixir
defp deps do
  [{:polyline, "~> 1.1"}]
end
```

## Usage

**[Full Documentation](https://pkinney.github.io/polyline_ex/Polyline.html)**

The encode functions accept a `precision` parameter that defines the
number of significant digits to retain when encoding.  The same precision
must be supplied to the decode or the resulting linestring will be incorrect.
The default is `5`, which correlates to approximately 1 meter of precision.

```elixir
Polyline.encode([{-120.2, 38.5}, {-120.95, 40.7}, {-126.453, 43.252}]) #+> "_p~iF~ps|U_ulLnnqC_mqNvxq`@"

Polyline.decode("_p~iF~ps|U_ulLnnqC_mqNvxq`@") #=> [{-120.2, 38.5}, {-120.95, 40.7}, {-126.453, 43.252}]
```
