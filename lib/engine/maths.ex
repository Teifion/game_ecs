defmodule GameEcs.Maths do
  # Easy method for limiting a number between two points
  # call with parameter to limit plus or minus
  def limit(v, b), do: limit(v, -b, b)
  def limit(v, lb, ub) do
    cond do
      v < lb -> lb
      v > ub -> ub
      true -> v
    end
  end
  
  
  def angle(a) do
    cond do
      a < 0 -> angle(a + 360)
      a > 360 -> angle(a - 360)
      true -> a
    end
  end
end