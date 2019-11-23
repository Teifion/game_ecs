defmodule GameEcs.Maths do
  @pi :math.pi
  @pi2 :math.pi*2
  
  def deg2rad(d), do: d * (@pi/180)
  def rad2deg(r), do: r * (180/@pi)

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
      a < 0 -> angle(a + @pi2)
      a > @pi2 -> angle(a - @pi2)
      true -> a
    end
  end
  
  def distance({x1, y1}, {x2, y2}) do
    a = abs(x1 - x2)
    b = abs(y1 - y2)
    :math.sqrt((a*a) + (b*b))
  end
  
  @doc """
  Given angles a1 and a2 returns a left/right atom
  saying which way is the shortest way to turn
  """
  @spec shortest_angle(float, float) :: :left | :right
  def shortest_angle(a1, a2) do
    cond do
      # Standard closer/further
      a1 > a2 and a1 - a2 < @pi -> :left
      a2 > a1 and a2 - a1 < @pi -> :right

      # These cover when you need to cross 0 degrees
      a1 > a2 and a1 - a2 > @pi -> :right
      a2 > a1 and a2 - a1 > @pi -> :left
    end
  end

  @spec angle_distance(float, float) :: float
  def angle_distance(a1, a2) do
    direction = shortest_angle(a1, a2)

    cond do
      # Standard closer/further
      direction == :left and a1 > a2 -> a1 - a2
      direction == :right and a2 > a1 -> a2 - a1

      # These cover when you need to cross 0 degrees 
      direction == :left and a1 < a2 -> @pi2 - (a2 - a1)
      direction == :right and a2 < a1 -> @pi2 - (a1 - a2)
    end
  end
  
  
  @spec calculate_angle({float, float}, {float, float}) :: float
  def calculate_angle({x1, y1}, {x2, y2}) do
    dx = x2 - x1
    dy = y2 - y1
    
    # Get 2D angle first
    sides = cond do
      dx == 0 and dy == 0 -> 0 # No angle, you are there already?
      dx == 0 and dy < 0 -> 0 # Go up
      dx == 0 and dy > 0 -> deg2rad(180) # Go down
      dx < 0 and dy == 0 -> deg2rad(270) # Go left
      dx > 0 and dy == 0 -> deg2rad(90) # Go right
      
      dx > 0 and dy < 0 -> {dx,      abs(dy), 0} # Right, up
      dx > 0 and dy > 0 -> {dx,      dy,      deg2rad(90)} # Right, down
      dx < 0 and dy > 0 -> {abs(dx), dy,      deg2rad(180)} # Left, down
      dx < 0 and dy < 0 -> {abs(dx), abs(dy), deg2rad(270)} # Left, up
    end

    case sides do
      {opp, adj, add} -> :math.atan(opp / adj) + add
      x -> x
    end
  end

  @spec calculate_angle({float, float, float}, {float, float, float}) :: {float, float}
  def calculate_angle({x1, y1, z1}, {x2, y2, z2}) do
    xy = calculate_angle({x1, y1}, {x2, y2})

    adj = distance({x1, y1}, {x2, y2})
    opp = abs(z2 - z1)
    yz = :math.atan(opp / adj)
    
    {xy, yz}
  end
end