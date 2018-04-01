defmodule Gol do
  alias Gol.Cell

  def build(cell_list) do
    Enum.map(cell_list, fn cell ->
      [x, y] = cell
      %Cell{x: x, y: y}
    end)
  end

  def tick(state) do
    still_alive =
      state
      |> Enum.filter(&will_be_alive(state, &1))

    new_cells =
      state
      |> Enum.map(&neighborhood/1)
      |> List.foldl([], &(&1 ++ &2))
      |> Enum.uniq()
      |> Enum.filter(&(not cell_at(state, &1)))
      |> Enum.filter(&will_be_alive(state, &1))

    still_alive ++ new_cells
  end

  def will_be_alive(state, location) do
    live_count = live_neighbors(state, location)

    if cell_at(state, location) do
      live_count == 2 || live_count == 3
    else
      live_count == 3
    end
  end

  def live_neighbors(state, location) do
    Enum.filter(neighborhood(location), fn loc ->
      cell_at(state, loc)
    end)
    |> length()
  end

  def cell_at(state, location) do
    [x, y] = location

    Enum.any?(state, fn [cx, cy] ->
      cx == x && cy == y
    end)
  end

  def neighborhood(loc) do
    [x, y] = loc

    [
      [x - 1, y - 1],
      [x, y - 1],
      [x + 1, y - 1],
      [x - 1, y],
      [x + 1, y],
      [x - 1, y + 1],
      [x, y + 1],
      [x + 1, y + 1]
    ]
  end

  def pretty_print_active_area(state) do
    [maxx, _] = Enum.max_by(state, fn [x, _] -> x end)
    [_, maxy] = Enum.max_by(state, fn [_, y] -> y end)
    [minx, _] = Enum.min_by(state, fn [x, _] -> x end)
    [_, miny] = Enum.min_by(state, fn [_, y] -> y end)

    miny..maxy
    |> Enum.map(fn y ->
      minx..maxx
      |> Enum.map(fn x ->
        string_for_cell(state, [x, y])
      end)
      |> Enum.join()
    end)
    |> Enum.join("\n")
  end

  def pretty_print(state) do
    -10..10
    |> Enum.map(fn y ->
      -10..10
      |> Enum.map(fn x ->
        string_for_cell(state, [x, y])
      end)
      |> Enum.join()
    end)
    |> Enum.join("\n")
  end

  def string_for_cell(state, location) do
    if cell_at(state, location), do: "*", else: "_"
  end

  def print_loop(state) do
    IO.puts(pretty_print(state))
    IO.puts("\n")
    :timer.sleep(1000)
    state |> tick() |> print_loop()
  end

  def run() do
    1..10
    |> Enum.map(fn y ->
      1..10
      |> Enum.map(fn x ->
        if :rand.uniform(6) == 1, do: [x, y], else: nil
      end)
    end)
    |> List.foldl([], &(&1 ++ &2))
    |> Enum.reject(&is_nil/1)
    |> print_loop()
  end
end
