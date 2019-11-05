defmodule GameEcs.Loader do
  # use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end
  
  def init() do
    {:ok, %{}}
  end
  
  def load(file_path) do
    json = _parse_file(file_path)
    
    _load_ships(json["ships"])
  end

  def _parse_file(file_path) do
    file_path
    |> File.read!
    |> Jason.decode!
  end

  def _load_ships(ships) do
    ships
    |> Enum.map(fn s ->
      [px, py, pz] = s["position"]
      [vx, vy, vz] = s["velocity"]
      
      GameEcs.Ship.new(position: %{posx: px, posy: py, posz: pz, velx: vx, vely: vy, velz: vz})
    end)
  end
end