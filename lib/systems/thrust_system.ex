defmodule GameEcs.ThrustSystem do
  @moduledoc """
    Increments ages of AgeComponents
  """

  alias GameEcs.ComponentRegistry
  alias GameEcs.Recorder

  def process do
    ComponentRegistry.get_combo(["AiComponent", "SpecsComponent"])
    # |> Enum.each(&dispatch/1)
  end

  defp dispatch(%{id: pid, state: s}) do
    # %{id: _pid, state: s} = GameEcs.Component.get(pid)

    # new_state = Map.merge(s, %{
    #   posx: s.posx + s.velx,
    #   posy: s.posy + s.vely,
    #   posz: s.posz + s.velz,
    # })

    # Recorder.record("Updated #{s.entity} position to #{inspect new_state}", [:action_system, :acquire_target])

    GameEcs.Component.update(pid, s)
  end
end
