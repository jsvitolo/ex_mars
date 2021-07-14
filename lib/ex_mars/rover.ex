defmodule ExMars.Rover do
  defstruct position: Position,
            commands: [],
            error: nil

  alias ExMars.Rover.Position

  def new(%Position{} = position, commands \\ []) do
    %__MODULE__{position: position, commands: commands}
  end

  def new(x, y, direction, commands \\ []) do
    new(%Position{x: x, y: y, direction: direction}, commands)
  end

  defimpl String.Chars, for: __MODULE__ do
    def to_string(%{error: nil} = rover),
      do: "#{rover.position}"

    def to_string(%{error: error} = rover),
      do: "#{rover.position} (error: #{error}, commands: #{rover.commands})"
  end
end
