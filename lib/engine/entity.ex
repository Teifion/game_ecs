defmodule GameEcs.Entity do
  @moduledoc """
    A base for creating new Entities.
  """

  alias GameEcs.EntityRegistry
  alias GameEcs.Component

  defstruct [:id, :components]

  @type id :: String.t
  @type components :: list(Component)
  @type t :: %GameEcs.Entity{
    id: String.t,
    # name: String.t,
    components: components
  }

  @doc "Creates a new entity"
  @spec build(components) :: t
  def build(components) do
    entity_id = GameEcs.Crypto.random_string(64)

    components = components
    |> Enum.map(fn %{id: id, state: state} ->
      Component.update(id, Map.put(state, :entity, entity_id))
    end)

    entity = %GameEcs.Entity{
      id: entity_id,
      components: components
    }

    EntityRegistry.insert(entity_id, entity) # Register component for systems to reference

    entity
  end

  @doc "Add components at runtime"
  def add(%GameEcs.Entity{id: id, components: components}, component) do
    %GameEcs.Entity{
      id: id,
      components: components ++ [component]
    }
  end

  @doc "Pulls the latest component states"
  @spec reload(t) :: t
  def reload(%GameEcs.Entity{ id: _id, components: components} = entity) do
    updated_components = components
      |> Enum.map(fn %{id: pid} ->
        Component.get(pid)
      end)

    %{entity | components: updated_components}
  end

  @doc "Pulls components for entity"
  @spec get_components(id) :: List.t
  def get_components(entity_id) do
    entity = entity_id
    |> EntityRegistry.get()
    
    reload(entity).components
  end
  
  @spec get_components(id, String.t) :: GameEcs.Component.t
  def get_components(entity_id, component_type) do
    entity = entity_id
    |> EntityRegistry.get()

    reload(entity).components
    |> Enum.filter(fn c ->
      c.type == component_type
    end)
  end

  @doc """
  Gets a singular component (of a specific type) from an entity
  """
  def get_component(entity_id, component_type) do
    get_components(entity_id)
    |> Enum.filter(fn c -> c.state.type == :"Elixir.GameEcs.#{component_type}" end)
    |> hd
    |> Map.get(:state)
  end
  
  @doc """
  Gets a singular value from a singular component of this enttiy
  """
  def get_component_property(entity_id, component_type, property_name) do
    get_component(entity_id, component_type)
    |> Map.get(property_name)
  end
end
