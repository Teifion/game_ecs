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
    |> Enum.map(&dispatch/1)
    |> Enum.each(&ComponentRegistry.do_updates/1)
  end

  # dispatch() is a reducer that takes in a state and an action and returns a new state
  def dispatch({entity_id, [%{id: pid, state: pos_c}, %{state: ai_c}]}) do
    # Do we change our facing?
    new_facing = if ai_c.ai_turn != {0, 0} do
      {ai_fxy, ai_fyz} = ai_c.ai_turn
      %{
        fxy: angle(pos_c.fxy + ai_fxy),
        fyz: angle(pos_c.fyz + ai_fyz)
      }
    else
      %{
        fxy: pos_c.fxy,
        fyz: pos_c.fyz
      }
    end

    # Do we apply thrust?
    new_velocity = if ai_c.ai_thrust != 0 do
      {physx, physy, physz} = Physics.apply_thrust({new_facing.fxy, new_facing.fyz}, ai_c.ai_thrust)

      %{
        velx: pos_c.velx + physx,
        vely: pos_c.vely + physy,
        velz: pos_c.velz + physz,
      }
    else
      %{
        velx: pos_c.velx,
        vely: pos_c.vely,
        velz: pos_c.velz,
      }
    end

    new_state = pos_c
    |> Map.merge(new_facing)
    |> Map.merge(new_velocity)

    Recorder.record("#{entity_id} turned from r#{inspect {pos_c.fxy, pos_c.fyz}} to r#{inspect {new_facing.fxy, new_facing.fyz}}", [:thrust_system, :turn])

    Recorder.record("#{entity_id} velocity to #{inspect {new_velocity.velx, new_velocity.vely, new_velocity.velz}}", [:thrust_system, :turn])

    [{pid, new_state}]
  end
  
  def do_thrust do
    
  end
end
