defmodule GameEcs.ActionSystem do
    @moduledoc """
    Allows entities with an AI component to make decisions
  """

  alias GameEcs.Recorder
  alias GameEcs.Component
  alias GameEcs.ComponentRegistry
  alias GameEcs.Entity

  def process do
    ComponentRegistry.get(:"Elixir.GameEcs.AiComponent")
    |> Enum.each(fn (pid) -> dispatch(pid, :drift) end)
  end

  # dispatch() is a reducer that takes in a state and an action and returns a new state
  defp dispatch(pid, _action) do
    state = GameEcs.Component.get(pid).state

    new_state = cond do
      state.target == nil ->
        acquire_target(state)
      true ->
        state
    end

    

    GameEcs.Component.update(pid, new_state)
  end

  defp acquire_target(self_state) do
    # We need to know what team we're on
    team = Entity.get_component_property(self_state.entity, "TeamComponent", :team)

    # Get a list of all possible targets
    entity_list = ComponentRegistry.get(:"Elixir.GameEcs.TeamComponent")
    |> Enum.map(fn id -> Component.get(id) end)
    |> Enum.filter(fn %{state: team_state} ->
      team_state.team != team
    end)
    |> Enum.map(fn %{state: team_state} ->
      team_state.entity
    end)

    # Now select one at random
    target = Enum.random(entity_list)
    
    Recorder.record("Updated #{self_state.entity} target to #{target}", [:action_system, :acquire_target])
    
    Map.put(self_state, :target, target)
  end
end
