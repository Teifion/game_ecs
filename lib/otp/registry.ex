defmodule GameEcs.Registry do
  @moduledoc """
    Component registry. Used by systems to locate components of its type.

    iex> {:ok, r} = GameEcs.Registry.start
    iex> GameEcs.Registry.insert("test", r)
    :ok
    iex> GameEcs.Registry.get("test")
    [#PID<0.87.0>]
  """

  def start do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end
  
  def start_link() do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def insert(component_type, component_pid) do
    Agent.update(__MODULE__, fn(registry) ->
      components = (Map.get(registry, component_type, []) ++ [component_pid])
      Map.put(registry, component_type, components)
    end)
  end

  def get(component_type) do
    Agent.get(__MODULE__, fn(registry) ->
      Map.get(registry, component_type, [])
    end)
  end
end
