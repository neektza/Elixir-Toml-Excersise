defmodule NasParserTest do
  use ExUnit.Case
  doctest NasParser

	  test "stringParsing" do
		input = ~s(opcija="nesto"\ndruga_opcija="nesto drugo")

		expected = %{
			"opcija" => "nesto",
			"druga_opcija" => "nesto drugo"
		}

		result = NasParser.parse(input)
		IO.inspect(result)
		assert(result == expected)
	end

	 test "arrayParsing" do
		input = ~s(opcija="nesto"\ndruga_opcija=["1","2","3","4"])

		expected = %{
			"opcija" => "nesto",
			"druga_opcija" => ["1","2","3","4"]
		}

		result = NasParser.parse(input)
		IO.inspect(result)
		assert(length(Map.keys(result)) == 2)
		assert(length(Map.values(result)) == 2)

		assert(result == expected)
	end

	test "nestedArrayParsing" do
		input = ~s(opcija="nesto"\ndruga_opcija=[["1","2","3","4"]],[5,6,7,8])

		expected = %{
			"opcija" => "nesto",
			"druga_opcija" => ["1","2","3","4"]
		}

		result = NasParser.parse(input)
		IO.inspect(result)
		assert(length(Map.keys(result)) == 2)
		assert(length(Map.values(result)) == 2)

		assert(result == expected)
	end


	test "intParsing" do
		input = ~s(nekalista = [1,2,3,4,5]\nbroj=7)

		expected = %{
			"nekalista" => [1,2,3,4,5],
			"broj" => 7
		}

		result = NasParser.parse(input)
		IO.inspect(result)
		assert(length(Map.keys(result)) == 2)
		assert(length(Map.values(result)) == 2)

		assert(result == expected)
	end

	test "floatParsing" do
		input = ~s(broj=7.421\nstring="string")

		expected = %{
			"broj" => 7.421,
			"string" => "string"
		}

		result = NasParser.parse(input)
		IO.inspect(result)
		assert(length(Map.keys(result)) == 2)
		assert(length(Map.values(result)) == 2)

		assert(result == expected)
	end


end
