defmodule GameEcs.TeamComponent do
  @moduledoc """

    {id: pid, state: state} = PositionComponent.new(%{posx: 1, posy: 2, posz: 3, velx: 4, vely: 5, velz: 6})

    {id: pid, state: state} = PositionComponent.new([[1, 2, 3], [4, 5, 6]])
  """
  use GameEcs.Component
  
  @component_type __MODULE__

  @doc "Initializes and validates state"
  def new(%{
    team: _
    } = initial_state) do
    GameEcs.Component.new(@component_type, initial_state)
  end
  
  def new(team) do
    new(%{
      team: team
    })
  end
end