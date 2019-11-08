defmodule GameEcs.PositionComponent do
  @moduledoc """

    {id: pid, state: state} = PositionComponent.new(%{posx: 1, posy: 2, posz: 3, velx: 4, vely: 5, velz: 6})

    {id: pid, state: state} = PositionComponent.new([[1, 2, 3], [4, 5, 6]])
  """
  use GameEcs.Component
  
  @component_type __MODULE__

  @doc "Initializes and validates state"
  def new(entity, %{
    fxy: _, fyz: _,
    posx: _, posy: _, posz: _,
    velx: _, vely: _, velz: _
    } = initial_state) do
    GameEcs.Component.new(@component_type, entity, initial_state)
  end
  
  def new(entity, [[posx, posy, posz], [velx, vely, velz], [fxy, fyz]]) do
    new(entity, %{
      fxy: fxy, fyz: fyz,
      posx: posx, posy: posy, posz: posz,
      velx: velx, vely: vely, velz: velz
    })
  end
end
