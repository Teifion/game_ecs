defmodule GameEcs.ActionMoveSystem do
  @moduledoc """
    Increments ages of AgeComponents
  """

  alias GameEcs.Maths
  alias GameEcs.ComponentRegistry
  alias GameEcs.Recorder
  import GameEcs.Maths, only: [limit: 2, limit: 3]

  def process do
    ComponentRegistry.get_combo(["AiComponent", "SpecsComponent"])
    |> Enum.filter(&dispatch_filter/1)
    |> Enum.each(&dispatch/1)
  end

  defp dispatch_filter({_entity_id, [%{state: _ai_c}, %{state: specs_c}]}) do
    specs_c.thrust > 0 or specs_c.turn_speed > 0
  end

  defp do_turn(ai_c, specs_c) do
    new_turn = ai_c.ai_turn
    
    {tx, ty} = new_turn
    # Recorder.record("Updated #{ai_c.entity} ai_turn to r#{inspect {tx, ty}}", [:ai, :turn])
    
    ai_c = Map.merge(ai_c, %{
      ai_turn: new_turn
    })
  end

  defp do_thrust(ai_c, specs_c) do
    new_thrust = ai_c.ai_thrust
    
    # Recorder.record("Updated #{ai_c.entity} ai_thrust to #{inspect new_thrust}", [:ai, :thrust])
    
    ai_c = Map.merge(ai_c, %{
      ai_thrust: new_thrust
    })
  end
  
  defp bound_actions(ai_c, specs_c) do
    # Max turn
    max_turn = specs_c.turn_speed
    {turn_xy, turn_yz} = ai_c.ai_turn

    new_turn = {limit(turn_xy, max_turn), limit(turn_yz, max_turn)}
    new_thrust = limit(ai_c.ai_thrust, specs_c.thrust)

    # If changes took place, log them
    if new_turn != ai_c.ai_turn do
      Recorder.record("Updated #{ai_c.entity} ai_turn bound at r#{inspect new_turn}", [:ai, :turn, :bound])
    end

    if new_thrust != ai_c.ai_thrust do
      Recorder.record("Updated #{ai_c.entity} ai_thrust bound to #{inspect new_thrust}", [:ai, :thrust, :bound])
    end

    ai_c = Map.merge(ai_c, %{
      ai_turn: new_turn,
      ai_thrust: new_thrust
    })
  end

  defp dispatch({entity_id, [%{id: pid, state: ai_c}, %{state: specs_c}]}) do
    ai_c = ai_c
    |> bound_actions(specs_c)
    |> do_turn(specs_c)
    |> do_thrust(specs_c)
    
    GameEcs.Component.update(pid, ai_c)
  end
end
