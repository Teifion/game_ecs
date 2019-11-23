defmodule GameEcs.MathsTest do
  use ExUnit.Case
  alias GameEcs.Maths
  
  defp deg(v), do: round(Maths.rad2deg(v))

  test "shortest angle" do
    values = [
      # Standard angles, both right of 0 degrees
      {20, 30, :right},
      {20, 10, :left},
      
      # Both left of 0 degrees
      {340, 350, :right},
      {340, 330, :left},
      
      # # Straddling 0 degrees
      {340, 20, :right},
      {20, 340, :left},
    ]

    for {a1, a2, expected} <- values do
      result = Maths.shortest_angle(a1, a2)
      assert result == expected, message: "Error with #{a1} -> #{a2}, expected #{expected} but got #{result}"
    end
  end
  
  test "angle_distance" do
    values = [
      # Standard angles, both right of 0 degrees
      {20, 30, 10},
      {20, 10, 10},
      
      # Both left of 0 degrees
      {340, 350, 10},
      {340, 330, 10},
      
      # # Straddling 0 degrees
      {340, 20, 40},
      # {20, 340, 40},
    ]

    for {a1, a2, expected} <- values do
      result = Maths.angle_distance(a1, a2)
      assert result == expected, message: "Error with #{a1} -> #{a2}, expected #{expected} but got #{result}"
    end
  end
  
  test "degrees and radians" do
    values = [
      {0, 0},
      {180, :math.pi},
      {360, :math.pi * 2},
      {45, :math.pi / 4},
      {90, :math.pi / 2},
    ]
    
    for {deg, rad} <- values do
      assert Maths.deg2rad(deg) == rad
      assert Maths.rad2deg(rad) == deg
    end
  end

  test "calculate_angle" do
    # 2D stuff
    values = [
      {{0, 0}, {4, -4}, Maths.deg2rad(45)},
      {{0, 0}, {4, 4}, Maths.deg2rad(135)},
      {{0, 0}, {-4, 4}, Maths.deg2rad(225)},
      {{0, 0}, {-4, -4}, Maths.deg2rad(315)},
    ]

    for {p1, p2, expected} <- values do
      result = Maths.calculate_angle(p1, p2)
      assert result == expected, message: "Error with #{inspect p1} -> #{inspect p2}, expected #{inspect {expected, deg(expected)}} but got #{inspect {result, deg(result)}}"
    end
    
    # 3D stuff
    values = [
      {{0, 0, 0}, {4, -4, 0}, {Maths.deg2rad(45), 0}},
      {{0, 0, 0}, {4, 4, 0}, {Maths.deg2rad(135), 0}},
      {{0, 0, 0}, {-4, 4, 0}, {Maths.deg2rad(225), 0}},
      {{0, 0, 0}, {-4, -4, 0}, {Maths.deg2rad(315), 0}},

      {{0, 0, 0}, {4, -4, 4}, {Maths.deg2rad(45), 0.6154797086703873}},
      {{0, 0, 0}, {4, 4, 4}, {Maths.deg2rad(135), 0.6154797086703873}},
      {{0, 0, 0}, {-4, 4, 4}, {Maths.deg2rad(225), 0.6154797086703873}},
      {{0, 0, 0}, {-4, -4, 4}, {Maths.deg2rad(315), 0.6154797086703873}}
    ]

    for {p1, p2, expected = {e1, e2}} <- values do
      result = {r1, r2} = Maths.calculate_angle(p1, p2)
      assert result == expected, message: "Error with #{inspect p1} -> #{inspect p2}, expected #{inspect {deg(e1), deg(e2)}} but got #{inspect {deg(r1), deg(r2)}}"
    end
  end
end
