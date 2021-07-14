defmodule ExMars.WorldMapTest do
  use ExUnit.Case, async: true

  alias ExMars.{Rover.Position, WorldMap}

  setup do
    %{world_map: %WorldMap{size: {5, 5}}, position: %Position{x: 1, y: 2}}
  end

  describe "WorldMap.move/4" do
    test "places rover on world_map", %{world_map: world_map, position: position} do
      {:ok, new} = WorldMap.move(world_map, position.x, position.y, position)

      assert new.rovers[{position.x, position.y}] == position
    end

    test "places rover outside of word_map", %{world_map: world_map, position: position} do
      assert {:error, :out_of_bounds} == WorldMap.move(world_map, 42, 42, position)
    end
  end
end
