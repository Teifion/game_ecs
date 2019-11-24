defmodule GameEcs.ComponentRegistry do
  @moduledoc """
    Component registry. Used by systems to locate components of its type.

    iex> {:ok, r} = GameEcs.ComponentRegistry.start
    iex> GameEcs.ComponentRegistry.insert("test", r)
    :ok
    iex> GameEcs.ComponentRegistry.get("test")
    [#PID<0.87.0>]
  """
  
  alias GameEcs.Component

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
      Map.get(registry, :"Elixir.GameEcs.#{component_type}", [])
    end)
  end
  

  # In theory we should be able to get a list of entity_ids from the components, we can drop any component from the list where it doesn't exist in an every shrinking list of entity_ids
  # Not sure if it is better to build up a list of entity_ids that are valid in one pass and select with the next or filter and select as we go
  
  
  @spec get_combo(List.t) :: List.t
  def get_combo(component_types) do
    component_types
    |> Enum.map(&get/1)
    |> Enum.map(&split_components/1)
    |> reduce_combo
  end
  
  @spec split_components(List.t) :: List.t
  defp split_components(clist) do
    # Takes a list of component pids and returns
    # a pair {entity_id, component}
    clist
    |> Enum.map(&Component.get/1)
    |> Enum.map(fn c = %{state: s} -> {s.entity, c} end)
  end
  
  # Take out the first item, we use that as something to build from as we go
  @spec reduce_combo(List.t) :: Map.t
  defp reduce_combo([acc | clist]) do
    acc
    |> Enum.map(fn {key, dict} -> {key, [dict]} end)
    |> Map.new
    |> reduce_combo(clist)
  end
  
  @spec reduce_combo(Map.t, List.t) :: Map.t
  defp reduce_combo(acc, []) do
    acc
  end
  
  defp reduce_combo(acc, [chead | ctail]) do
    acc_keys = Map.keys(acc)
    head_map = Map.new(chead)
    head_keys = Map.keys(head_map)
    
    valid_keys = MapSet.intersection(MapSet.new(acc_keys), MapSet.new(head_keys))
    
    acc
    |> Enum.filter(fn {key, _} -> key in valid_keys end)
    |> Enum.map(fn {key, dict} ->
      {key, dict ++ [head_map[key]]}
    end)
    |> Map.new
  end
  
  def do_updates(components) do
    components
    |> Enum.map(fn {pid, new_state} ->
      Component.update(pid, new_state)
    end)
  end
end
