defmodule GameEcs.Physics do
  @moduledoc """
  
  """
  
  @doc """
  
  """
  @spec apply_thrust({float, float}, float) :: {float, float, float}
  def apply_thrust(_, 0), do: {0, 0, 0}
  def apply_thrust(%{fxy: fxy, fyz: fyz}, thrust), do: apply_thrust({fxy, fyz}, thrust)
  def apply_thrust({fxy, fyz}, thrust) do
    vx = thrust
    vy = thrust
    vz = thrust

    {vx, vy, vz}
  end
end