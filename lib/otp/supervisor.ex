defmodule GameEcs.Supervisor do
  use Supervisor

  @ticks_per_second 60

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      # worker(GameEcs.Registry, [[name: GameEcs.Registry]])
      worker(GameEcs.Registry, []),
      worker(GameEcs.Loop, [%{start_time: :os.system_time(:millisecond), tick_time: 1000/@ticks_per_second, update_ticks: @ticks_per_second}]),
      # worker(GameEcs.Loader, [])
    ]
    
    supervise(children, strategy: :one_for_one)
  end
end