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

      iex> PHP.array_count_values(%{a: "a", b: "b", c: "c", d: "a"})
      %{"a" => 2, "b" => 1, "c" => 1}

      iex> PHP.array_count_values([3, 5, 3, "foo", "bar", "foo"])
      %{3 => 2, 5 => 1, "bar" => 1, "foo" => 2}

      iex> PHP.array_count_values([true, 4.2, 42, "fubar"])
      %{42 => 1, 4.2 => 1, true => 1, "fubar" => 1}
  """
  def array_count_values(array) do
    Enum.reduce(array, %{}, fn(item_in_arr, counter) ->
      case item_in_arr do
        {_, element} -> element2 = element
        element -> element2 = element
      end
      Map.put(counter, element2, Map.get(counter, element2, 0) + 1)
    end)
  end

  @doc """
  Checks if the given key or index exists in the array.
  ## Examples
      iex> PHP.array_key_exists(:name, %{name: "JerryPan"})
      true

      iex> PHP.array_key_exists(:id, %{name: "JerryPan"})
      false

      iex> PHP.array_key_exists(:id, [name: "JerryPan"])
      false
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

      iex> PHP.array_keys([name: "JerryPan", id: 88])
      [:name, :id]
  """
  def array_keys(array) do
    Dict.keys(array)
  end

  @doc """
  Applies the callback to the elements of the given arrays.
  ## Examples
      iex> PHP.array_map(nil, [1, 2, 3])
      [1, 2, 3]

      iex> PHP.array_map(&(&1 * 2), [1, 3, 5])
      [2, 6, 10]

      iex> PHP.array_map(&(&1), %{:name => "JerryPan", :id => 88, 1 => "year", 2 => "2015"})
      ["year", "2015", 88, "JerryPan"]

      iex> PHP.array_map(fn(element) -> element * 5 end, [a: 1, b: 2, c: 3])
      [5, 10, 15]

      iex> PHP.array_map(fn(element) -> element * 10 end, %{a: 1, b: 2, c: 3})
      [10, 20, 30]

      iex> PHP.array_map(nil, [1, 2, 3], [5, 6, 7])
      [[1, 5], [2, 6], [3, 7]]

      iex> PHP.array_map(nil, [a: 1, b: 2], [5, 6, 7])
      [[1, 5], [2, 6], [nil, 7]]

      iex> PHP.array_map(&(&1 * &2), [1, 2, 3], [5, 6, 7])
      [5, 12, 21]

      iex> PHP.array_map(&(&1 * &2), [a: 1, b: 2, c: 3], [a: 5, b: 6, c: 7])
      [5, 12, 21]
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

  defp array_map_2_private(fun, [hd_1 | tail_1], [hd_2 | tail_2], acc) do
    array_map_2_private(fun, tail_1, tail_2, [array_map_2_fn(hd_1, hd_2, fun) | acc])
  end
  defp array_map_2_private(fun, [], [hd_2 | tail_2], acc) do
    array_map_2_private(fun, [], tail_2, [array_map_2_fn(nil, hd_2, fun) | acc])
  end
  defp array_map_2_private(fun, [hd_1 | tail_1], [], acc) do
    array_map_2_private(fun, tail_1, [], [array_map_2_fn(hd_1, nil, fun) | acc])
  end
  defp array_map_2_private(_fun, [], [], acc) do
    :lists.reverse(acc)
  end

  @doc """
  Calculate the product of values in an array.
  ## Examples
      iex> PHP.array_product([1, 2, 3])
      6

      iex> PHP.array_product([a: 1, b: 2, c: 3])
      6

      iex> PHP.array_product(%{a: 1, b: 2, c: 3})
      6
  """
  def array_product(array) do
    Enum.reduce(array, 1, fn
                            {_, e}, acc -> acc * e
                            e, acc -> acc * e
                          end)
  end

  @doc """
  Pick one or more random entries out of an array.
  ## Examples
      iex > PHP.array_rand([1, 2, 3])
      3

      iex > PHP.array_rand([a: 10, b: 20, c: 30])
      30

      iex > PHP.array_rand(%{a: 100, b: 200, c: 300})
      100
  """
  def array_rand(array, _num \\ 1) do
    << a :: 32, b :: 32, c :: 32 >> = :crypto.rand_bytes(12)
    :random.seed(a, b, c)
    case Enum.at(array, :random.uniform(Enum.count(array)) - 1) do
      {_, e} -> e
      e -> e
    end
  end

  @doc """
  Return an array with elements in reverse order.
  ## Examples
      iex> PHP.array_reverse([1, 2, 3])
      [3, 2, 1]
  """
  def array_reverse(list) do
    Enum.reverse(list)
  end

  @doc """
  Searches the array for a given value and returns the corresponding key if successful.
  ## Examples
      iex> PHP.array_search("JerryPan", %{id: 888, user_name: "JerryPan"})
      :user_name

      iex> PHP.array_search("JerryPan", [id: 888, user_name: "JerryPan"])
      :user_name

      iex> PHP.array_search("Tom", [id: 888, user_name: "JerryPan"])
      nil
  """
  def array_search(needle, array) do
    if is_list(array) do
      array_search_private(needle, array)
    else
      array_search_private(needle, Dict.to_list(array))
    end
  end

  defp array_search_private(needle, [{ret, needle} | _rest]) do
    ret
  end
  defp array_search_private(needle, [_ | rest]) do
    array_search_private(needle, rest)
  end
  defp array_search_private(_needle, []) do
    nil
  end

  @doc """
  Calculate the sum of values in an array.
  ## Examples
      iex> PHP.array_sum([4, 9, 182.6])
      195.6

      iex> PHP.array_sum([a: 4, c: 9, b: 182.6])
      195.6

      iex> PHP.array_sum(%{a: 4, c: 9, b: 182.6})
      195.6
  """
  def array_sum(array) do
    Enum.reduce(array, 0, fn(item_in_arr, total) ->
      case item_in_arr do
        {_, element} -> element2 = element
        element -> element2 = element
      end
      total + element2
    end)
  end

  @doc """
  Removes duplicate values from an array.
  ## Examples
      iex> PHP.array_unique(['Kevin', 'Kevin', 'van', 'Zonneveld', "Kevin"])
      ['Kevin', 'van', 'Zonneveld', "Kevin"]

      iex> PHP.array_unique(%{'a' => 'green', 0 => 'red', 'b' => 'green', 1 => 'blue', 2 => 'red'})
      %{0 => 'red', 1 => 'blue', 'a' => 'green'}
  """
  def array_unique(array) when is_list(array) do
    do_uniq(:is_list, array, [])
  end
  def array_unique(%{} = array) do
    Enum.reduce(array, %{}, fn({key, element}, acc) ->
      case array_search(element, acc) do
        nil  -> Map.put(acc, key, element)
        _old_key -> acc
      end
    end)
  end

  defp do_uniq(:is_list, [h|t], acc) do
    case :lists.member(h, acc) do
      true  -> do_uniq(:is_list, t, acc)
      false -> do_uniq(:is_list, t, [h|acc])
    end
  end
  defp do_uniq(:is_list, [], acc) do
    :lists.reverse(acc)
  end

  def sleep(second) do
    :timer.sleep(second * 1000)
  end
end

# IO.puts "-----------------------------------------------------------"
# IO.inspect PHP.array_unique(['Kevin', 'Kevin', 'van', 'Zonneveld', "Kevin"]) == ['Kevin', 'van', 'Zonneveld', "Kevin"]
# IO.inspect PHP.array_unique(%{'a' => 'green', 0 => 'red', 'b' => 'green', 1 => 'blue', 2 => 'red'})
# IO.puts "-----------------------------------------------------------"

# :io.format "~s: ~p~n", ["PHP.sleep(1)", PHP.sleep(1)]
