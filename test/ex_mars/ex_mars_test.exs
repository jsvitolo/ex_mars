defmodule ExMarsTest do
  use ExUnit.Case
  doctest ExMars

  alias ExMars.{Rover, Rover.Position, WorldMap}

  setup do
    {:ok, server} = WorldMap.start_link()

    %{server: server}
  end

  test "builds rover to world_map", %{server: server} do
    rover = Rover.new(1, 2, "N")

    assert map_size(WorldMap.get_state(server)) == 0

    ExMars.build_rovers(server, [rover])

    refute map_size(WorldMap.get_state(server)) == 0
  end

  test "builds rover with first input", %{server: server} do
    rovers = [Rover.new(1, 2, "N", ~w(L M L M L M L M M))]
    [new_rover] = ExMars.build_rovers(server, rovers)

    assert new_rover.position == %Position{x: 1, y: 3, direction: "N"}
  end

  test "builds rover with second input", %{server: server} do
    rovers = [Rover.new(3, 3, "E", ~w(M M R M M R M R R M))]
    [new_rover] = ExMars.build_rovers(server, rovers)

    assert new_rover.position == %Position{x: 5, y: 1, direction: "E"}
  end

  test "builds a list of rover at world_map", %{server: server} do
    rovers = [
      Rover.new(1, 2, "N", ~w(L M L M L M L M M)),
      Rover.new(3, 3, "E", ~w(M M R M M R M R R M))
    ]

    new_rovers = ExMars.build_rovers(server, rovers)
    positions = new_rovers |> Enum.map(& &1.position)

    assert positions == [
             %Position{x: 1, y: 3, direction: "N"},
             %Position{x: 5, y: 1, direction: "E"}
           ]
  end
end
