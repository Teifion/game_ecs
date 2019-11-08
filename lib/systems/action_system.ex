defmodule GameEcs.ActionSystem do
    @moduledoc """
    Allows entities with an AI component to make decisions
  """

  require Logger

  def process do
    GameEcs.ComponentRegistry.get(:"Elixir.GameEcs.AiComponent")
    |> Enum.each(fn (pid) -> dispatch(pid, :drift) end)
  end

  # dispatch() is a reducer that takes in a state and an action and returns a new state
  defp dispatch(pid, _action) do
    c = %{id: pid, entity: epid, state: s} = GameEcs.Component.get(pid)

    entity = Agent.get(epid, fn state -> state end)
    IO.puts "AI State"
    IO.inspect entity
    IO.inspect pid
    IO.inspect epid
    IO.inspect s
    IO.puts ""

    new_state = s

    # Logger.debug fn ->
    #   "Updated #{inspect pid} to #{inspect new_state}"
    # end

    GameEcs.Component.update(pid, new_state)
  end
end
