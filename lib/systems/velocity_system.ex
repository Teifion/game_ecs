defmodule GameEcs.VelocitySystem do
  @moduledoc """
    Increments ages of AgeComponents
  """

  alias GameEcs.Recorder

  def process do
    GameEcs.ComponentRegistry.get("PositionComponent")
    |> Enum.each(fn (pid) -> dispatch(pid, :drift) end)
  end

  # dispatch() is a reducer that takes in a state and an action and returns a new state
  defp dispatch(pid, _action) do
    %{id: _pid, state: s} = GameEcs.Component.get(pid)

    new_state = Map.merge(s, %{
      posx: s.posx + s.velx,
      posy: s.posy + s.vely,
      posz: s.posz + s.velz,
    })

    Recorder.record("Updated #{s.entity} position to #{inspect {new_state.posx, new_state.posy, new_state.posz}}", [:velocity_system])

    GameEcs.Component.update(pid, new_state)
  end
end
