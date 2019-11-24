defmodule GameEcs.ThrustSystem do
  @moduledoc """
    Increments ages of AgeComponents
  """

  alias GameEcs.ComponentRegistry
  alias GameEcs.Recorder
  
  alias GameEcs.Physics
  import GameEcs.Maths, only: [angle: 1]

  def process do
    ComponentRegistry.get_combo(["PositionComponent", "AiComponent"])
    |> Enum.filter(&dispatch_filter/1)
    |> Enum.each(&dispatch/1)
  end
  
  defp dispatch_filter({_entity_id, [_, %{state: ai_c}]}) do
    # ai_c.thrust > 0 or specs_c.turn_speed > 0
    true
  end

  # dispatch() is a reducer that takes in a state and an action and returns a new state
  defp dispatch({entity_id, [%{id: pid, state: pos_c}, %{state: ai_c}]}) do
    # Do we change our facing?
    new_facing = if ai_c.ai_turn do
      {ai_fxy, ai_fyz} = ai_c.ai_turn
      %{
        fxy: angle(pos_c.fxy + ai_fxy),
        fyz: angle(pos_c.fyz + ai_fyz)
      }
    else
      %{}
    end
    
    # Do we apply thrust?
    new_velocity = if ai_c.ai_thrust != 0 do
      {physx, physy, physz} = Physics.apply_thrust(new_facing, ai_c.ai_thrust)
      
      %{
        velx: pos_c.velx + physx,
        vely: pos_c.velx + physy,
        velz: pos_c.velx + physz,
      }
    else
      %{}
    end
    
    new_state = pos_c
    |> Map.merge(new_facing)
    |> Map.merge(new_velocity)

    Recorder.record("Updated #{entity_id} facing to r#{inspect {new_facing.fxy, new_facing.fyz}}", [:thrust_system, :turn])
    
    Recorder.record("Updated #{entity_id} velocity to #{inspect new_velocity}", [:thrust_system, :turn])
    
    # IO.puts "NS"
    # IO.inspect new_state
    # IO.puts ""

    GameEcs.Component.update(pid, new_state)
  end
end
