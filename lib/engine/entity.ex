defmodule GameEcs.Entity do
  @moduledoc """
    A base for creating new Entities.
  """

  defstruct [:id, :components]

  @type id :: String.t
  @type components :: list(GameEcs.Component)
  @type t :: %GameEcs.Entity{
    id: String.t,
    components: components
  }

  @doc "Creates a new entity"
  @spec build(components) :: t
  def build(components) do
    %GameEcs.Entity{
      id: GameEcs.Crypto.random_string(64),
      components: components
    }
  end

  @doc "Add components at runtime"
  def add(%GameEcs.Entity{ id: id, components: components}, component) do
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
        GameEcs.Component.get(pid)
      end)

    %{entity | components: updated_components}
  end
end
