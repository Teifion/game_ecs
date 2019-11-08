defmodule GameEcs.TimeSystem do
  @moduledoc """
    Increments ages of AgeComponents
  """

  require Logger

  def process do
    GameEcs.ComponentRegistry.get(:"Elixir.GameEcs.PositionComponent")
    |> Enum.each(fn (pid) -> dispatch(pid, :increment) end)
  end

  # dispatch() is a reducer that takes in a state and an action and returns a new state
  defp dispatch(pid, _action) do
    %{id: _pid, state: state} = GameEcs.Component.get(pid)
    
    # new_state = case action do
    #   :increment ->
    #     Map.put(state, :age, state.age + 1)
    #   :decrement ->
    #     Map.put(state, :age, state.age - 1)
    #   _ ->
    #     state
    # end
    
    new_state = state
    
    # Logger.debug fn ->
    #   "Updated #{inspect pid} to #{inspect new_state}"
    # end
    
    GameEcs.Component.update(pid, new_state)
  end
end
