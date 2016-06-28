defmodule NasParser do

	#Main

	def parse(input) do
		
		iterateLines(String.split(input,"\n"), Map.new())

	end


	# Line by line interation

	defp iterateLines([h|t], map) do
			if !empty?(h) do

				[opt|val] = String.split(h,"=")
				val = extractValue(val)
				
				cond do
					
					string?(val) ->
						val = trimQuotes(val)
					containsBrackets?(val) ->
						val = formatElements(pluckValBetweenBrackets(val), [])
					stringInt?(val) ->
						val = stringToInt(val)
					stringFloat?(val) ->
						val = stringToFloat(val)
					
				end
				
				map = Map.put(map, String.trim(opt), val)
			end
			iterateLines(t,map)
	end

	defp iterateLines([], map) do
	  	map
	end


	# String 
	defp string?(val) do
		(String.slice(val, 0, 1) == "\"" and String.slice(val, -1, 1) == "\"") or (String.slice(val, 0, 1) == "'" and String.slice(val, -1, 1) == "'")
	end

	defp trimQuotes(val) do
		Regex.replace(~r/\"/, String.trim(val,"'"), "")
	end


	# Integer 
	defp stringInt?(val) do
		Regex.match?(~r/^[0-9]+$/,val)
	end

	defp stringToInt(val) do
		elem(Integer.parse(val),0)
	end


	# Float 
	defp stringFloat?(val) do
		Regex.match?(~r/^[0-9].[0-9]+$/,val)
	end

	defp stringToFloat(val) do
		elem(Float.parse(val),0)
	end


	# List
	defp containsBrackets?(val) do
		String.slice(val, 0, 1) == "[" and String.slice(val, -1, 1) == "]"
	end

	defp pluckValBetweenBrackets(val) do
		String.split(String.slice(val,1, String.length(val)-2), ",")
	end

	defp formatElements([element|rest], newList) do
		if !string?(element) do
			newList = newList ++ [elem(Integer.parse(element),0)]	
		else
			newList = newList ++ [trimQuotes(element)]
		end
		
		formatElements(rest,newList)
	end

	defp formatElements([], newList) do
		newList
	end	


	# Other
	defp empty?(val) do
		String.trim(val) == ""
	end


	defp extractValue(val) do
		String.trim(Enum.at(val,0))
	end

	


end
