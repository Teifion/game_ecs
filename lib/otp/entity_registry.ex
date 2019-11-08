defmodule GameEcs.EntityRegistry do
  @moduledoc """
    Entity registry. Used by systems to locate entities of its type.

    iex> {:ok, r} = GameEcs.EntityRegistry.start
    iex> GameEcs.EntityRegistry.insert("test", r)
    :ok
    iex> GameEcs.EntityRegistry.get("test")
    [#PID<0.87.0>]
  """

  def start do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end
  
  def start_link() do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def insert(entity_type, entity) do
    Agent.update(__MODULE__, fn(registry) ->
      entities = (Map.get(registry, entity_type, []) ++ [entity])
      Map.put(registry, entity_type, entities)
    end)
  end

  def get(entity_type) do
    Agent.get(__MODULE__, fn(registry) ->
      Map.get(registry, entity_type, [])
    end)
  end
end
