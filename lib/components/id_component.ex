defmodule GameEcs.IdComponent do
  @moduledoc """
    A component for keeping an age for something.

    {id: pid, state: state} = IdComponent.new(%{age: 1})
  """
  use GameEcs.Component
  
  @component_type __MODULE__
  
  @doc "Initializes and validates state"
  def new(%{name: _name} = initial_state) do
    GameEcs.Component.new(@component_type, initial_state)
  end
end
