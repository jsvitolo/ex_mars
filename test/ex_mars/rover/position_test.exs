defmodule ExMars.Rover.PositionTest do
  use ExUnit.Case

  alias ExMars.Rover.Position

  describe "Position.apply/2" do
    test "turn left when facing N" do
      position = %Position{x: 1, y: 2, direction: "N"}
      assert Position.apply(position, "L") == %Position{position | direction: "W"}
    end

    test "turn left when facing S" do
      position = %Position{x: 1, y: 2, direction: "S"}
      assert Position.apply(position, "L") == %Position{position | direction: "E"}
    end

    test "turn left when facing E" do
      position = %Position{x: 1, y: 2, direction: "E"}
      assert Position.apply(position, "L") == %Position{position | direction: "N"}
    end

    test "turn left when facing W" do
      position = %Position{x: 1, y: 2, direction: "W"}
      assert Position.apply(position, "L") == %Position{position | direction: "S"}
    end

    test "turn right when facing N" do
      position = %Position{x: 1, y: 2, direction: "N"}
      assert Position.apply(position, "R") == %Position{position | direction: "E"}
    end

    test "turn right when facing S" do
      position = %Position{x: 1, y: 2, direction: "S"}
      assert Position.apply(position, "R") == %Position{position | direction: "W"}
    end

    test "turn right when facing E" do
      position = %Position{x: 1, y: 2, direction: "E"}
      assert Position.apply(position, "R") == %Position{position | direction: "S"}
    end

    test "turn right when facing W" do
      position = %Position{x: 1, y: 2, direction: "W"}
      assert Position.apply(position, "R") == %Position{position | direction: "N"}
    end

    test "move when facing N" do
      position = %Position{x: 2, y: 3, direction: "N"}
      assert Position.apply(position, "M") == %Position{position | x: 2, y: 4}
    end

    test "move when facing S" do
      position = %Position{x: 2, y: 3, direction: "S"}
      assert Position.apply(position, "M") == %Position{position | x: 2, y: 2}
    end

    test "move when facing E" do
      position = %Position{x: 2, y: 3, direction: "E"}
      assert Position.apply(position, "M") == %Position{position | x: 3, y: 3}
    end

    test "move when facing W" do
      position = %Position{x: 2, y: 3, direction: "W"}
      assert Position.apply(position, "M") == %Position{position | x: 1, y: 3}
    end
  end
end
