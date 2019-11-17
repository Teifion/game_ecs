defmodule GameEcs.Ship do
  def new(opts \\ []) do
    GameEcs.Entity.build([
      GameEcs.PositionComponent.new(opts[:position] || %{pos_x: 0, pos_y: 0, pos_z: 0, vel_x: 0, vel_y: 0, vel_z: 0, fxy: 0, fzy: 0}),
      GameEcs.AiComponent.new(opts[:ai]),
      GameEcs.TeamComponent.new(opts[:team]),
      GameEcs.SpecsComponent.new(opts[:specs])
    ])
  end
  
  def new2(opts \\ []) do
    GameEcs.Entity.build([
      GameEcs.PositionComponent.new(opts[:position] || %{pos_x: 0, pos_y: 0, pos_z: 0, vel_x: 0, vel_y: 0, vel_z: 0, fxy: 0, fzy: 0}),
      GameEcs.TeamComponent.new(opts[:team]),
      GameEcs.SpecsComponent.new(opts[:specs])
    ])
  end
end
