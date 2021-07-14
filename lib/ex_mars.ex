defmodule ExMars do
  @moduledoc """
  ExMars
  """

  alias ExMars.{Rover, Rover.Position, WorldMap}

  def start(inputs) do
    case ExMars.InputInterpreter.interpret(inputs) do
      {:error, reason} ->
        reason

      {world_map_size, rovers} ->
        {:ok, world_map} = WorldMap.start_link(size: world_map_size)
        build_rovers(world_map, rovers)
    end
  end

  defp build_rovers(world_map, rovers) do
    rovers
    |> Enum.map(fn rover ->
      Task.async(fn -> build_rover(world_map, rover) end)
    end)
    |> Enum.map(fn pid ->
      Task.await(pid)
    end)
  end

  defp build_rover(world_map, %Rover{position: position} = rover) do
    case WorldMap.deploy_rover(world_map, position.x, position.y, position) do
      :ok ->
        execute_commands(world_map, rover)

      {:error, reason} ->
        %Rover{rover | error: reason}
    end
  end

  defp execute_commands(_world_map, %Rover{commands: []} = rover) do
    rover
  end

  defp execute_commands(
         world_map,
         %Rover{commands: [command | commands], position: position} = rover
       ) do
    new_position = Position.apply(position, command)

    WorldMap.update_rover(
      world_map,
      position.x,
      position.y,
      new_position.x,
      new_position.y,
      new_position
    )
    |> case do
      :ok ->
        execute_commands(world_map, %Rover{rover | commands: commands, position: new_position})

      {:error, reason} ->
        %Rover{rover | error: reason}
    end
  end
end
