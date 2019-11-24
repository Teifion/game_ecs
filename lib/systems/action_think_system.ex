defmodule GameEcs.ActionThinkSystem do
    @moduledoc """
    Allows entities with an AI component to make decisions
  """

  alias GameEcs.Recorder
  alias GameEcs.Component
  alias GameEcs.ComponentRegistry
  alias GameEcs.Entity
  alias GameEcs.Maths

  def process do
    ComponentRegistry.get("AiComponent")
    |> Enum.map(&dispatch/1)
    |> Enum.each(&ComponentRegistry.do_updates/1)
  end

  # dispatch() is a reducer that takes in a state and an action and returns a new state
  defp dispatch(pid) do
    state = Component.get(pid).state

    # Do we need a target?
    state = if state.target == nil, do: acquire_target(state), else: state

    # Turn towards the target
    state = if state.target != nil, do: face_target(state), else: state

    # Potentially move towards the target
    state = if state.target != nil, do: approach_target(state), else: state
    
    # GameEcs.Component.update(pid, state)
    [{pid, state}]
  end

  # defp reset_flags(state) do
  #   Map.merge(state, %{
  #     ai_turn: nil,
  #     ai_thrust: nil
  #   })
  # end

  def acquire_target(self_state) do
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
    
    Recorder.record("#{self_state.entity} set target to #{target}", [:action_system, :acquire_target])

    Map.put(self_state, :target, target)
  end

  def face_target(self_state) do
    this = Entity.get_component(self_state.entity, "PositionComponent")
    target = Entity.get_component(self_state.target, "PositionComponent")

    # Get the desired facing
    {txy, tyz} = Maths.calculate_angle({this.posx, this.posy, this.posz}, {target.posx, target.posy, target.posz})

    # Now set the AI turn to take us towards the desired facing
    new_turn = {
      Maths.angle_adjust(this.fxy, txy),
      Maths.angle_adjust(this.fyz, tyz),
    }
    
    if self_state.ai_turn != new_turn do
      if self_state.ai_turn == {0, 0} do
        Recorder.record("#{self_state.entity} ai_turn turn completed r#{inspect {txy, tyz}}", [:action_system, :face_target])
      else
        Recorder.record("#{self_state.entity} ai_turn turning r#{inspect new_turn} from r#{inspect {this.fxy, this.fyz}} aiming for r#{inspect {txy, tyz}}", [:action_system, :face_target])
      end
    end

    self_state = Map.put(self_state, :ai_turn, new_turn)

    self_state
  end
  
  def approach_target(self_state) do
    {txy, tyz} = self_state.ai_turn
    
    # Only thrust if we're facing the right way
    new_thrust = if abs(txy) < 0.1 and abs(tyz) < 0.1 do
      Entity.get_component_property(self_state.entity, "SpecsComponent", :thrust)
    else
      0
    end
    
    if self_state.ai_thrust != new_thrust do
      Recorder.record("#{self_state.entity} ai_thrust to #{inspect new_thrust}", [:action_system, :approach_target])
    end
    
    self_state = Map.put(self_state, :ai_thrust, new_thrust)
    
    self_state
  end
end
