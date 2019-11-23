defmodule GameEcs.ActionThinkSystem do
    @moduledoc """
    Allows entities with an AI component to make decisions
  """

  alias GameEcs.Recorder
  alias GameEcs.Component
  alias GameEcs.ComponentRegistry
  alias GameEcs.Entity

  def process do
    ComponentRegistry.get("AiComponent")
    |> Enum.each(fn (pid) -> dispatch(pid) end)
  end

  # dispatch() is a reducer that takes in a state and an action and returns a new state
  defp dispatch(pid) do
    state = Component.get(pid).state

    # Do we need a target?
    state = if state.target == nil, do: acquire_target(state), else: state

    # Turn towards the target
    state = if state.target != nil, do: face_target(state), else: state

    # Move!
    state = if state.ai_thrust != 0, do: approach_target(state), else: state
    
    GameEcs.Component.update(pid, state)
  end
  
  # defp reset_flags(state) do
  #   Map.merge(state, %{
  #     ai_turn: nil,
  #     ai_thrust: nil
  #   })
  # end

  defp acquire_target(self_state) do
    # We need to know what team we're on
    team = Entity.get_component_property(self_state.entity, "TeamComponent", :team)

    # Get a list of all possible targets
    entity_list = ComponentRegistry.get("TeamComponent")
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
  
  defp face_target(self_state) do
    self_state = Map.put(self_state, :ai_turn, {45, -45})

    Recorder.record("Updated #{self_state.entity} ai_turn to #{inspect self_state.ai_turn}", [:action_system, :face_target])

    self_state
  end
  
  defp approach_target(self_state) do
    self_state
  end
end
