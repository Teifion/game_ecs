defmodule GameEcs.Entity do
  @moduledoc """
    A base for creating new Entities.
  """

  defstruct [:id, :type, :components]

  @type id :: String.t
  @type type :: String.t
  @type components :: list(GameEcs.Component)
  @type t :: %GameEcs.Entity{
    id: String.t,
    type: type,
    # name: String.t,
    components: components
  }

  @doc "Creates a new entity"
  @spec build(type, components) :: t
  def build(type, components) do
    entity = %GameEcs.Entity{
      id: GameEcs.Crypto.random_string(64),
      type: type,
      components: components
    }

    GameEcs.EntityRegistry.insert(type, entity) # Register component for systems to reference

    entity
  end

  @doc "Add components at runtime"
  def add(%GameEcs.Entity{id: id, type: type, components: components}, component) do
    %GameEcs.Entity{
      id: id,
      type: type,
      components: components ++ [component]
    }
  end

  @doc "Pulls the latest component states"
  @spec reload(t) :: t
  def reload(%GameEcs.Entity{ id: _id, components: components} = entity) do
    updated_components = components
      |> Enum.map(fn %{id: pid} ->
        GameEcs.Component.get(pid)
      end)

    %{entity | components: updated_components}
  end
end
