defmodule GameEcs.AiComponent do
  @moduledoc """
    A component that allows the entity to perform certain actions
  """
  use GameEcs.Component
  
  @component_type __MODULE__

  @doc "Initializes and validates state"
  def new(entity, %{
    target: _
    } = initial_state) do
    GameEcs.Component.new(@component_type, entity, initial_state)
  end
  
  def new(entity, target) do
    new(entity, %{
      target: target
    })
  end
end