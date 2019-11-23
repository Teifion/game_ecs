defmodule GameEcs do
  use Application
  
  # Run using 
  # iex -S mix
  # or
  # mix run --no-halt
  
  @moduledoc """
  Documentation for GameEcs.
  """

  @doc """
  Hello world.

  ## Examples

      iex> GameEcs.hello
      :world

  """
  def start(_type, _args) do
    import Supervisor.Spec
    
    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(GameEcs.Supervisor, []),
      # worker(GameEcs.ComponentRegistry, [[name: GameEcs.ComponentRegistry]]),
      
      
      # # Start the endpoint when the application starts
      # supervisor(CentaurWeb.Endpoint, []),
      # supervisor(CentaurWeb.Presence, []),
      # # Start your own worker by calling: Centaur.Worker.start_link(arg1, arg2, arg3)
      # # worker(Centaur.Worker, [arg1, arg2, arg3]),
      
      # # supervisor(Task.Supervisor, [
      # #   [name: Centaur.TaskSupervisor, restart: :transient]
      # # ])
      # supervisor(CentaurWeb.Developer.Hook.Supervisor, []),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GameEcs.Application]

    start_result = Supervisor.start_link(children, opts)
    # Call all our sub function st
    {:ok, t} = Task.start(fn -> play() end)
    send(t, :begin)
    start_result
    
    # Supervisor.start_link(children, opts)
  end
  
  defp play() do
    receive do
      :begin -> nil
    end

    # "assets/game.json"
    # |> File.read!
    # |> Jason.decode!

    # entities = GameEcs.Loader.load_json()
    
    # :observer.start
    
    GameEcs.Loader.load("assets/game.json")
    # GameEcs.Loop.begin(6)
    
    # card1 = GameEcs.Ship.new()
    # _card2 = GameEcs.Card.new(visual: %{name: "Card 2", x: 2, y: 1, icon: ""})
    
    # _card1 = GameEcs.Entity.reload(card1)
    
    
    # # New components can be added at runtime, adding new behaviour to existing entities.
    # bunny = GameEcs.Entity.add(bunny, AgeComponent.new(%{age: 10}))

    # # State updates will also be pushed to components added at runtime.
    # TimeSystem.process
    # bunny = GameEcs.Entity.reload(bunny)
  end
end
