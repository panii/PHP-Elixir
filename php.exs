defmodule PHP do

	@moduledoc """
	PHP-Elixir trys to implements a set of PHP functions in Elixir language. This idea is influenced by the PHPJS project! [http://phpjs.org/about]
	"""

	@doc """
	Split an array into chunks. Not support $preserve_keys.
	## Examples
		iex> PHP.array_chunk([2, 4, 6], 1)
		[[2], [4], [6]]
		iex> PHP.array_chunk([2, 4, 6, 8], 2)
		[[2, 4], [6, 8]]
		iex> PHP.array_chunk([2, 4, 6], 2)
		[[2, 4], [6]]
	"""
	def array_chunk(input, size) when size > 0 do
		array_chunk_private(input, size, 1, [], [])
	end

	defp array_chunk_private([hd | tail], size, size, acc_temp, acc_all) do
		array_chunk_private(tail, size, 1, [], [:lists.reverse([hd | acc_temp]) | acc_all])
	end
	defp array_chunk_private([hd | tail], size, length_temp, acc_temp, acc_all) do
		array_chunk_private(tail, size, length_temp + 1, [hd | acc_temp], acc_all)
	end
	defp array_chunk_private([], _size, _length_temp, [], acc_all) do
		:lists.reverse(acc_all)
	end
	defp array_chunk_private([], _size, _length_temp, acc_temp, acc_all) do
		:lists.reverse([:lists.reverse(acc_temp) | acc_all])
	end

	@doc """
	Creates an array by using one array for keys and another for its values.
	## Examples
			iex> PHP.array_combine(["a", "b", "c"], [1, 2, 3])
			%{"a" => 1, "b" => 2, "c" => 3}
			iex> PHP.array_combine([:a, :b, :c], [1, 2, 3])
			%{a: 1, b: 2, c: 3}
	"""
	def array_combine(keys, values) do
		:maps.from_list(Enum.zip(keys, values))
	end

	@doc """
	Counts all the values of an array.
	## Examples
			iex> PHP.array_count_values(["a", "b", "c", "a"])
			%{"a" => 2, "b" => 1, "c" => 1}
			iex> PHP.array_count_values([3, 5, 3, "foo", "bar", "foo"])
			%{3 => 2, 5 => 1, "bar" => 1, "foo" => 2}
			iex> PHP.array_count_values([true, 4.2, 42, "fubar"])
			%{42 => 1, 4.2 => 1, true => 1, "fubar" => 1}
	"""
	def array_count_values(arr) do
		Enum.reduce(arr, %{}, fn(item_in_arr, counter) ->
			case Map.fetch(counter, item_in_arr) do
				:error -> Map.put(counter, item_in_arr, 1)
				{:ok, int_value} -> Map.put(counter, item_in_arr, int_value + 1)
			end
		end)
	end
	
	@doc """
	Checks if the given key or index exists in the array.
	## Examples
			iex> PHP.array_key_exists(:name, %{name: "JerryPan"})
			true
	"""
	def array_key_exists(key, search) do
		Dict.has_key?(search, key)
	end
	
	@doc """
	Return all the keys of an array.
	## Examples
			iex> PHP.array_keys(%{name: "JerryPan", id: 88})
			[:id, :name]
			iex> PHP.array_keys(%{:name => "JerryPan", :id => 88, 1 => "year", 2 => "2015"})
			[1, 2, :id, :name]
	"""
	def array_keys(array) do
		Dict.keys(array)
	end
	
	def sleep(second) do
		:timer.sleep(second * 1000)
	end
end



IO.inspect PHP.array_keys(%{:name => "JerryPan", :id => 88, 1 => "year", 2 => "2015"})


# :io.format "~p~n", [888]
# :io.format "~s: ~p~n", ["PHP.sleep(1)", PHP.sleep(1)]
