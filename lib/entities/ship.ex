defmodule GameEcs.Ship do
  def new(opts \\ []) do
    GameEcs.Entity.build("ship", [
      GameEcs.PositionComponent.new(self(), opts[:position] || %{pos_x: 0, pos_y: 0, pos_z: 0, vel_x: 0, vel_y: 0, vel_z: 0, fxy: 0, fzy: 0}),
      GameEcs.AiComponent.new(self(), opts[:ai])
    ])
  end
end
