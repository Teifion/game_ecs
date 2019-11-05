defmodule GameEcs.PositionComponent do
  @moduledoc """

    {id: pid, state: state} = PositionComponent.new(%{x: 1, y: 2, z: 3})
  """
  use GameEcs.Component
  
  @component_type __MODULE__

  @doc "Initializes and validates state"
  def new(%{
    posx: _, posy: _, posz: _,
    velx: _, vely: _, velz: _
    } = initial_state) do
    GameEcs.Component.new(@component_type, initial_state)
  end
end
