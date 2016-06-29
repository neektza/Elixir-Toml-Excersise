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
						val = formatListElements(parseList(String.graphemes(pluckValBetweenBrackets(val)), "", "[", 0), [])
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
	defp string?(string) do
		(String.slice(string, 0, 1) == "\"" and String.slice(string, -1, 1) == "\"") or (String.slice(string, 0, 1) == "'" and String.slice(string, -1, 1) == "'")
	end

	defp trimQuotes(string) do
		Regex.replace(~r/\"/, String.trim(string,"'"), "")
	end


	# Integer 
	defp stringInt?(string) do
		Regex.match?(~r/^[0-9]+$/,string)
	end

	defp stringToInt(string) do
		elem(Integer.parse(string),0)
	end


	# Float 
	defp stringFloat?(string) do
		Regex.match?(~r/^[0-9].[0-9]+$/,string)
	end

	defp stringToFloat(string) do
		elem(Float.parse(string),0)
	end


	# List
	defp containsBrackets?(string) do
		String.slice(string, 0, 1) == "[" and String.slice(string, -1, 1) == "]"
	end


	defp parseList([char | rest], memory, search, lvl) do

		cond do
	
			char == "[" and search == "[" ->
				memory = memory <> char
				search = "]"
				lvl = lvl + 1
			char == "[" and search == "]" ->
				lvl = lvl + 1
				memory = memory <> char
			char == "]" and search == "]" and lvl > 1 ->
				lvl = lvl - 1
				memory = memory <> char
			char == "]" and search == "]" and lvl == 1 ->
				memory = memory <> char
				search = "["
				lvl = lvl - 1
			char == "," and lvl == 0 ->
				memory = memory <> "###"
			true ->
				memory = memory <> char
		end
		
		
		parseList(rest, memory, search, lvl)
	end

	
	defp parseList([], memory, search,lvl) do
		[] ++ String.split(memory,"###")
	end

	defp pluckValBetweenBrackets(string) do
		String.slice(string,1, String.length(string)-2)
	end

	defp formatListElements([element|rest], newList) do

		cond do
			string?(element) ->
				newList = newList ++ [trimQuotes(element)]
			containsBrackets?(element) ->
				newList = newList ++ [formatListElements(parseList(String.graphemes(pluckValBetweenBrackets(element)),"","[", 0), [])]
			stringInt?(element)->
				newList = newList ++ [stringToInt(element)]
			stringFloat?(element) ->
				newList = newList ++ [stringToFloat(element)]
		end

		
		formatListElements(rest,newList)
	end

	defp formatListElements([], newList) do
		newList
	end	


	# Other
	defp empty?(string) do
		String.trim(string) == ""
	end


	defp extractValue(string) do
		String.trim(Enum.at(string,0))
	end


end
