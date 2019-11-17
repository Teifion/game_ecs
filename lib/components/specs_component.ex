defmodule GameEcs.SpecsComponent do
  @moduledoc """

    {id: pid, state: state} = PositionComponent.new(%{posx: 1, posy: 2, posz: 3, velx: 4, vely: 5, velz: 6})

    {id: pid, state: state} = PositionComponent.new([[1, 2, 3], [4, 5, 6]])
  """
  use GameEcs.Component
  
  @component_type __MODULE__

  @doc "Initializes and validates state"
  def new(%{
    thrust: _, turn_speed: _,
    } = initial_state) do
    GameEcs.Component.new(@component_type, initial_state)
  end
  
  def new([[thrust, turn_speed]]) do
    new(%{
      thrust: thrust, turn_speed: turn_speed,
    })
  end
end