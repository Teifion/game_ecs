defmodule GameEcs.ThrustTest do
  use ExUnit.Case
  alias GameEcs.ThrustSystem
  # import GameEcs.Maths, only: [rad2deg: 1, deg2rad: 1]
  
  @blank_pos %{
    fxy: 0, fyz: 0,
    velx: 0, vely: 0, velz: 0
  }
  
  test "do nothing" do
    ai = %{
      ai_turn: {0, 0},
      ai_thrust: 0
    }

    [{_, new_state}] = ThrustSystem.dispatch({"", [%{id: -1, state: @blank_pos}, %{state: ai}]})

    assert new_state.fxy == 0
    assert new_state.fyz == 0
    assert new_state.velx == 0
    assert new_state.vely == 0
    assert new_state.velz == 0
  end
  
  test "turn, no thrust" do
    ai = %{
      ai_turn: {1, 1},
      ai_thrust: 0
    }

    [{_, new_state}] = ThrustSystem.dispatch({"", [%{id: -1, state: @blank_pos}, %{state: ai}]})

    assert new_state.fxy == 1
    assert new_state.fyz == 1
    assert new_state.velx == 0
    assert new_state.vely == 0
    assert new_state.velz == 0
  end
  
  test "thrust, no turn" do
    ai = %{
      ai_turn: {0, 0},
      ai_thrust: 10
    }

    [{_, new_state}] = ThrustSystem.dispatch({"", [%{id: -1, state: @blank_pos}, %{state: ai}]})

    assert new_state.fxy == 0
    assert new_state.fyz == 0
    assert new_state.velx == 0
    assert new_state.vely == -10
    assert new_state.velz == 0
  end
end