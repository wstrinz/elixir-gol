defmodule GolTest do
  use ExUnit.Case
  doctest Gol

  @example_state [
    [0, 0],
    [0, 1],
    [1, 0]
  ]

  test "checks live neighbors" do
    assert Gol.live_neighbors(@example_state, [1, 1]) == 3
  end

  test "tick" do
    example_next_state = [
      [0, 0],
      [0, 1],
      [1, 0],
      [1, 1]
    ]

    assert Gol.tick(@example_state) == example_next_state
  end
end
