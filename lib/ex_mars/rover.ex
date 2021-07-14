defmodule ExMars.Rover do
  defstruct position: Position,
            commands: []

  alias ExMars.Rover.Position

  def new(%Position{} = position, commands \\ []) do
    %__MODULE__{position: position, commands: commands}
  end

  def new(x, y, direction, commands \\ []) do
    new(%Position{x: x, y: y, direction: direction}, commands)
  end
end
