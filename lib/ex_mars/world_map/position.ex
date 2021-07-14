defmodule ExMars.WorldMap.Position do
  @moduledoc """
  The WorldMap Position
  """

  defstruct x: nil, y: nil

  def apply({x, y} = _posistion) do
    %__MODULE__{x: x, y: y}
  end
end
