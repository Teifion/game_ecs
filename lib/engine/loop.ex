defmodule GameEcs.Loop do
  use GenServer
  
  alias GameEcs.Recorder
  require Logger

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end
  
  def init(args) do
    {:ok, %{
      start_time: args.start_time,
      tick_time: round(args.tick_time),
      update_ticks: args.update_ticks,
      tick_subs: [],
      update_subs: [],
    }}
  end
  
  def begin(max_ticks) do
    Recorder.record("Begin", [:engine_loop])
    GenServer.call(__MODULE__, {:begin, max_ticks})
  end

  
  def handle_continue(:send_update, state) do
    {:noreply, send_update(state)}
  end

  def handle_call({:begin, max_ticks}, _from, state) do
    state = Map.merge(state, %{max_ticks: max_ticks, ticks: 0})
    schedule(0)
    {:reply, "started", state}
  end

  def handle_info(:main_loop, state) do
    # start_time = :os.system_time(:millisecond)
    
    state = main_loop(state)
    
    # target_ms = start_time + state.tick_time
    # actual_ms = Kernel.max(target_ms - :os.system_time(:millisecond), 0)
    
    if state.ticks <= state.max_ticks do
      # schedule(actual_ms)
      schedule(1)
      
      if rem(state.ticks, state.update_ticks) == 0 do
        Process.send_after(self(), :send_update, 0)
      end
    else
      Recorder.dump()
      |> GameEcs.Export.export_logs
      
      IO.puts "max_ticks reached"
    end
    
    {:noreply, state}
  end
  
  def handle_info(:send_update, state) do
    send_update(state)
    {:noreply, state}
  end


  defp send_update(state) do
    {{_, _, _}, {_, m, s}} = :calendar.universal_time()
    Recorder.record("Update sent: #{state.ticks} at #{m}:#{s}", [:engine_loop])
  end

  defp main_loop(state) do
    # elapsed = :os.system_time(:millisecond) - state.start_time
    
    # :timer.sleep :rand.uniform(10)
    
    # IO.puts "GameEcs.Loop after #{elapsed}, tick: #{state.ticks}"
    
    Recorder.record("Tick #{state.ticks} starting", [:engine_loop, :tick])
    
    GameEcs.TimeSystem.process
    GameEcs.ActionThinkSystem.process
    GameEcs.ActionMoveSystem.process
    # GameEcs.ActionShootSystem.process
    GameEcs.ThrustSystem.process
    GameEcs.VelocitySystem.process
    
    Recorder.record("Tick #{state.ticks} completed", [:engine_loop, :tick])
    Map.merge(state, %{ticks: state.ticks + 1})
  end

  defp schedule(ms) do
    Process.send_after(self(), :main_loop, ms)
  end
end