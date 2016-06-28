defmodule NasParser do


	def empty?(val) do
			String.trim(val) == ""
	end

	def trimValue(val) do
			Regex.replace(~r/\"/, String.trim(Enum.at(val,0)), "")
	end

	def parseIfArray(val) do
		if containsBrackets?(val) do
			pluckValBetweenBrackets(val)
		else
			val
		end
	end

	def iterateLines([h|t], map) do
			if !empty?(h) do

				[opt|val] = String.split(h,"=")
				
				val= parseIfArray(trimValue(val))
				
				map = Map.put(map, String.trim(opt), val)
			end
			iterateLines(t,map)
	end

	def iterateLines([], map) do
	  	map
	end

	def parse(input) do
		
		NasParser.iterateLines(String.split(input,"\n"), Map.new())

	end

	defp pluckValBetweenBrackets(val) do
		String.split(String.slice(val,1, String.length(val)-2), ",")
	end

	defp containsBrackets?(val) do
		String.slice(val, 0, 1) == "[" and String.slice(val, -1, 1) == "]"
	end

end

# %{
#	opcija: "slkdfjsdkf",
#	druga_opcija: "ldskfjsdkfj"
# }