defmodule GameEcs.VelocitySystem do
  @moduledoc """
    Increments ages of AgeComponents
  """

  require Logger

  def process do
    GameEcs.Registry.get(:"Elixir.GameEcs.PositionComponent")
    |> Enum.each(fn (pid) -> dispatch(pid, :drift) end)
  end

  # dispatch() is a reducer that takes in a state and an action and returns a new state
  defp dispatch(pid, _action) do
    %{id: _pid, state: s} = GameEcs.Component.get(pid)

    new_state = %{
      posx: s.posx + s.velx,
      posy: s.posy + s.vely,
      posz: s.posz + s.velz,
    }
    Logger.debug fn ->
      "Updated #{inspect pid} to #{inspect new_state}"
    end

    GameEcs.Component.update(pid, new_state)
  end
end
