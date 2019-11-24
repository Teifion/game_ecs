defmodule GameEcs.Recorder do
  use GenServer
  require Logger
  
  def start_link(args \\ []) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end
  
  def record(msg) do
    GenServer.cast(__MODULE__, {:record, msg, []})
  end
  
  def record(msg) do
    GenServer.cast(__MODULE__, {:record, msg, []})
  end
  
  def record(msg, tags) when is_atom(tags) do
    GenServer.cast(__MODULE__, {:record, msg, [tags]})
  end
  
  def record(msg, tags) do
    GenServer.cast(__MODULE__, {:record, msg, tags})
  end
  
  def add_entity(entity_id, entity_data) do
    GenServer.cast(__MODULE__, {:add_entity, entity_id, entity_data})
  end
  
  def dump() do
    GenServer.call(__MODULE__, {:dump})
  end
  
  def handle_call({:dump}, _from, state) do
    {:reply, state, state}
  end
  
  def handle_cast({:record, msg, tags}, state) do
    flag = if state.prefs.method == :whitelist do
      tags
      |> Stream.filter(fn t -> t in state.prefs.tags end)
      |> Enum.any?
    else
      f = tags
      |> Stream.filter(fn t -> t not in state.prefs.tags end)
      |> Enum.any?
      
      not f
    end

    # Do we output the message into the debugger?
    if flag do
      tag_string = tags
      |> Enum.map(&to_string/1)
      |> Enum.join(", ")
      
      Logger.debug fn -> "#{formatter(msg)} -- #{tag_string}" end
    end
    
    {:noreply, Map.put(state, :logs, state.logs ++ [{msg, tags}])}
  end
  
  def handle_cast({:add_entity, entity_id, entity_data}, state) do
    {:noreply, Map.put(state, :entities, Map.put(state.entities, entity_id, entity_data))}
  end
  
  
  
  defp formatter(msg) do
    Regex.replace(~r/([a-zA-Z0-9_\-]{12})[a-zA-Z0-9_\-]{52}/, msg, "\\1")
  end
  
  def init(_args) do
    {:ok, %{
      logs: [],
      entities: %{},
      prefs: %{
        method: :whitelist,
        tags: [:velocity_system]
      }
    }}
  end
end