defmodule ExMars.WorldMap do
  use GenServer

  @default_size {5, 5}

  defstruct size: @default_size, rovers: %{}

  ## Client API

  def start_link(opts \\ []) do
    world_map_size = Keyword.get(opts, :size)
    GenServer.start_link(__MODULE__, {:ok, size: world_map_size})
  end

  def deploy_rover(server, x, y, position) do
    GenServer.call(server, {:deploy_rover, x, y, position})
  end

  def update_rover(server, x, y, new_x, new_y, position) do
    GenServer.call(server, {:update_rover, x, y, new_x, new_y, position})
  end

  def get_state(server) do
    GenServer.call(server, :get_state)
  end

  ## Server Callbacks

  def init({:ok, opts}) do
    Process.flag(:trap_exit, true)
    {:ok, %__MODULE__{size: opts[:size] || @default_size}}
  end

  def handle_call({:deploy_rover, x, y, position}, _from, world_map) do
    case move(world_map, x, y, position) do
      {:ok, world_map} ->
        {:reply, :ok, world_map}

      {:error, reason} ->
        {:reply, {:error, reason}, world_map}
    end
  end

  def handle_call({:update_rover, x, y, new_x, new_y, position}, _from, world_map) do
    case update(world_map, x, y, new_x, new_y, position) do
      {:ok, world_map} ->
        {:reply, :ok, world_map}

      {:error, reason} ->
        {:reply, {:error, reason}, world_map}
    end
  end

  def handle_call(:get_state, _from, world_map) do
    {:reply, world_map.rovers, world_map}
  end

  ## Internal

  def move(%__MODULE__{} = world_map, x, y, rover) do
    with :ok <- inside_world_map(world_map, x, y),
         :ok <- cell_not_occupied(world_map, x, y),
         rovers = world_map.rovers |> Map.put({x, y}, rover),
         world_map = %__MODULE__{world_map | rovers: rovers},
         do: {:ok, world_map}
  end

  def delete(%__MODULE__{} = world_map, x, y) do
    rovers =
      world_map.rovers
      |> Map.delete({x, y})

    %__MODULE__{world_map | rovers: rovers}
  end

  def update(%__MODULE__{} = world_map, x, y, new_x, new_y, rover) do
    world_map
    |> delete(x, y)
    |> move(new_x, new_y, rover)
  end

  defp inside_world_map(%__MODULE__{} = world_map, x, y) do
    {max_x, max_y} = world_map.size

    if x in 0..max_x and y in 0..max_y do
      :ok
    else
      {:error, :out_of_bounds}
    end
  end

  defp cell_not_occupied(%__MODULE__{} = world_map, x, y) do
    if world_map.rovers[{x, y}] == nil do
      :ok
    else
      {:error, :cell_occupied}
    end
  end
end
