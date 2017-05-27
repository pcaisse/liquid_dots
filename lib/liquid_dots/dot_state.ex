defmodule LiquidDots.DotState do
  @moduledoc """
  Keep track of dot state.
  """

  @doc """
  Start link to agent.
  """
  def start_link(name \\ __MODULE__, map \\ %{}) do
    Agent.start_link(fn -> {map, Map.size(map)} end, name: name)
  end

  @doc """
  Get all dots.
  """
  def get_dots(agent \\ __MODULE__) do
    {dots, _} = Agent.get(agent, &(&1))
    dots
  end

  def put_new_dot(agent \\ __MODULE__, dot) do
    Agent.get_and_update(agent, fn({map, count}) ->
      new_count = count + 1
      new_dot_id = Integer.to_string(new_count)
      updated_map = Map.put_new(map, new_dot_id, dot)
      updated_state = {updated_map, new_count}
      new_dot_state = Map.take(updated_map, [new_dot_id])
      {new_dot_state, updated_state}
    end)
  end

  def delete_dot(agent \\ __MODULE__, dot_id) do
    Agent.get_and_update(agent, fn({map, count}) ->
      updated_state = {Map.delete(map, dot_id), count}
      {dot_id, updated_state}
    end)
  end
end
