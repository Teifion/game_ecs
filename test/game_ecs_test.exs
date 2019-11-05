defmodule GameEcsTest do
  use ExUnit.Case
  doctest GameEcs

  test "greets the world" do
    assert GameEcs.hello() == :world
  end
end
