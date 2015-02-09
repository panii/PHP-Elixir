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
      case item_in_arr do
        {_, element} -> element2 = element
        element -> element2 = element
      end
      case Map.fetch(counter, element2) do
        :error -> Map.put(counter, element2, 1)
        {:ok, int_value} -> Map.put(counter, element2, int_value + 1)
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

  @doc """
  Applies the callback to the elements of the given arrays.
  ## Examples
      iex> PHP.array_map(nil, [1, 2, 3])
      [1, 2, 3]
      iex> PHP.array_map(&(&1 * 2), [1, 2, 3])
      [2, 4, 6]
      iex> PHP.array_map(fn(element) -> element * 5 end, [a: 1, b: 2, c: 3])
      [5, 10, 15]
      iex> PHP.array_map(fn(element) -> element * 10 end, %{a: 1, b: 2, c: 3})
      [10, 20, 30]
      iex> PHP.array_map(nil, [1, 2, 3], [4, 5, 6])
      [[1, 4], [2, 5], [3, 6]]
      iex> PHP.array_map(nil, [a: 1, b: 2], [4, 5, 6])
      [[1, 4], [2, 5], [nil, 6]]
      iex> PHP.array_map(&(&1 * &2), [1, 2, 3], [4, 5, 6])
      [4, 10, 18]
      iex> PHP.array_map(&(&1 * &2), [a: 1, b: 2, c: 3], [a: 4, b: 5, c: 6])
      [4, 10, 18]
  """
  def array_map(fun, list1) do
    if fun == nil do
      list1
    else
      Enum.map(list1, fn(element) -> array_map_1_fn(element, fun) end)
    end
  end
  def array_map(fun, list1, list2) do
    if fun == nil do
      fun = fn(element1, element2) -> [element1, element2] end
    end
    array_map_2_private(fun, list1, list2, [])
  end

  defp array_map_1_fn({_, element}, fun) do
    fun.(element)
  end
  defp array_map_1_fn(element, fun) do
    fun.(element)
  end

  defp array_map_2_fn({_, element1}, {_, element2}, fun) do
    fun.(element1, element2)
  end
  defp array_map_2_fn({_, element1}, element2, fun) do
    fun.(element1, element2)
  end
  defp array_map_2_fn(element1, {_, element2}, fun) do
    fun.(element1, element2)
  end
  defp array_map_2_fn(element1, element2, fun) do
    fun.(element1, element2)
  end

  defp array_map_2_private(_fun, [], [], acc) do
    :lists.reverse(acc)
  end
  defp array_map_2_private(fun, [hd_1 | tail_1], [hd_2 | tail_2], acc) do
    array_map_2_private(fun, tail_1, tail_2, [array_map_2_fn(hd_1, hd_2, fun) | acc])
  end
  defp array_map_2_private(fun, [], [hd_2 | tail_2], acc) do
    array_map_2_private(fun, [], tail_2, [array_map_2_fn(nil, hd_2, fun) | acc])
  end
  defp array_map_2_private(fun, [hd_1 | tail_1], [], acc) do
    array_map_2_private(fun, tail_1, [], [array_map_2_fn(hd_1, nil, fun) | acc])
  end

  def sleep(second) do
    :timer.sleep(second * 1000)
  end
end




IO.inspect PHP.array_count_values(%{a: "a", b: "b", c: "c", d: "a"})
# IO.inspect PHP.array_map(nil, %{:name => "JerryPan", :id => 88, 1 => "year", 2 => "2015"})

# :io.format "~s: ~p~n", ["PHP.sleep(1)", PHP.sleep(1)]
