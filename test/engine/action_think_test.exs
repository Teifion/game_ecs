defmodule GameEcs.ActionThinkTest do
  use ExUnit.Case
  alias GameEcs.ActionThinkSystem

  @blank_ai %{
    entity: "",
    ai_turn: {0, 0},
    ai_thrust: 0
  }
  
  @blank_spec %{
    turn_speed: 1,
    thrust: 10
  }

  test "do nothing" do
    ai = Map.merge(@blank_ai, %{})

    new_state = ActionThinkSystem.bound_actions(ai, @blank_spec)
    assert new_state == @blank_ai
  end

  # test "test bounding" do
  #   ai = Map.merge(@blank_ai, %{
  #     ai_turn: {2, 2},
  #     ai_thrust: 20
  #   })

  #   new_state = ActionMoveSystem.bound_actions(ai, @blank_spec)
  #   assert new_state == %{
  #     entity: "",
  #     ai_turn: {1, 1},
  #     ai_thrust: 10
  #   }
  # end
end