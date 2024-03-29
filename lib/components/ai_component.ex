defmodule GameEcs.AiComponent do
  @moduledoc """
    A component that allows the entity to perform certain actions
  """
  use GameEcs.Component
  
  @component_type __MODULE__

  @doc "Initializes and validates state"
  def new(%{
    target: _
    } = initial_state) do
    
    # Defaults
    initial_state = Map.merge(initial_state, %{
      ai_turn: {0, 0},
      ai_thrust: 0
    })
    GameEcs.Component.new(@component_type, initial_state)
  end

  def new(target) do
    new(%{
      target: target
    })
  end
end