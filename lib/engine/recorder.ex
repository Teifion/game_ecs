defmodule GameEcs.Recorder do
  use GenServer
  require Logger
  
  def start_link(args \\ []) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
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
  
  def dump() do
    GenServer.call(__MODULE__, {:dump})
  end
  
  def handle_call({:dump}, _from, state) do
    {:reply, state, state}
  end
  
  def handle_cast({:record, msg, tags}, state) do
    tag_string = tags
    |> Enum.map(&to_string/1)
    |> Enum.join(", ")
    
    # Shorten entity names, TODO: use a flag for this
    msg = Regex.replace(~r/([a-zA-Z0-9_\-]{12})[a-zA-Z0-9_\-]{52}/, msg, "\\1")
    
    msg = "#{msg} -- #{tag_string}"
    
    
    
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

    new_state = if flag do
      Logger.debug fn -> msg end
      Map.put(state, :entries, state.entries ++ [msg])
    else
      state
    end
    
    {:noreply, new_state}
  end
  
  def init(_args) do
    {:ok, %{
      entries: [],
      prefs: %{
        method: :whitelist,
        tags: [:ai, :turn, :thrust]
      }
    }}
  end
end