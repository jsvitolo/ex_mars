defmodule ExMarsTest do
  use ExUnit.Case
  doctest ExMars

  test "greets the world" do
    assert ExMars.hello() == :world
  end
end
