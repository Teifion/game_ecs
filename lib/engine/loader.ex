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
      if s["name"] == "Ship 1" do
        GameEcs.Ship.new(
          position: [s["position"], s["velocity"], s["facing"]],
          specs: [s["acceleration"]],
          team: s["team"],
        )
      else
        GameEcs.Ship.new(
          position: [s["position"], s["velocity"], s["facing"]],
          specs: [s["acceleration"]],
          team: s["team"],
        )
      end
    end)
  end
end