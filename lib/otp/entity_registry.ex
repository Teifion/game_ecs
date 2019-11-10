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

  def insert(entity_id, entity) do
    Agent.update(__MODULE__, fn(registry) ->
      Map.put(registry, entity_id, entity)
    end)
  end

  def get(entity_id) do
    Agent.get(__MODULE__, fn(registry) ->
      Map.get(registry, entity_id, nil)
    end)
  end
end
