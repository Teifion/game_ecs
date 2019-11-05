defmodule GameEcs.AgeComponent do
  @moduledoc """
    A component for keeping an age for something.

    {id: pid, state: state} = AgeComponent.new(%{age: 1})
  """
  use GameEcs.Component
  
  @component_type __MODULE__
  
  @doc "Initializes and validates state"
  def new(%{age: _age} = initial_state) do
    initial_state = Map.merge(initial_state, %{birth: :os.system_time(:millisecond)})
    
    GameEcs.Component.new(@component_type, initial_state)
  end
end
