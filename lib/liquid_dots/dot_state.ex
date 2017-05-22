defmodule LiquidDots.DotState do
  @moduledoc """
  Keep track of dot state.
  """

  def start_link do
    Agent.start_link(fn -> {%{}, 0} end, name: __MODULE__)
  end

  def get do
    Agent.get(__MODULE__, &(&1))
  end

  @doc """
  Get all dots.
  """
  def get_dots do
    {dots, _} = get()
    dots
  end

  @doc """
  Get the count of all dots that ever existed.
  """
  def get_count do
    {_, count} = get()
    count
  end

  def put_new_dot(dot) do
    Agent.get_and_update(__MODULE__, fn({map, count}) ->
      new_count = count + 1
      new_dot_id = Integer.to_string(new_count)
      updated_map = Map.put_new(map, new_dot_id, dot)
      updated_state = {updated_map, new_count}
      new_dot_state = Map.take(updated_map, [new_dot_id])
      {new_dot_state, updated_state}
    end)
  end

  def delete_dot(dot_id) do
    Agent.get_and_update(__MODULE__, fn({map, count}) ->
      updated_state = {Map.delete(map, dot_id), count}
      {dot_id, updated_state}
    end)
  end
end
