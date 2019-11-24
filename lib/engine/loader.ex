defmodule GameEcs.Loader do
  # use GenServer
  import GameEcs.Maths, only: [deg2rad: 1]
  alias GameEcs.Recorder

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end
  
  def init() do
    {:ok, %{}}
  end
  
  def load(file_path) do
    json = _parse_file(file_path)
    
    _load_ships(json["ships"])
    |> Enum.each(fn ({sid, sname}) -> Recorder.add_entity(sid, sname) end)
  end

  def _parse_file(file_path) do
    file_path
    |> File.read!
    |> Jason.decode!
  end

  def _load_ships(ships) do
    ships
    |> Enum.map(fn s ->
      ship = GameEcs.Ship.new(
        position: [s["position"], s["velocity"], _angle(s["facing"])],
        specs: [s["acceleration"], _angle(s["turn"])],
        team: s["team"],
      )
      
      {ship.id, %{name: s["name"]}}
    end)
  end
  
  
  defp _angle(v) when is_list(v) do
    Enum.map(v, &_angle/1)
  end
  
  defp _angle(v), do: deg2rad(v)
end