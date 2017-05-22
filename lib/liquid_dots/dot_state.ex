defmodule LiquidDots.DotState do
  @moduledoc """
  Keep track of dot state.
  """

  def start_link do
    Agent.start_link(fn -> {%{}, 0} end, name: __MODULE__)
  end

  @doc """
  Get all dots.
  """
  def get_dots do
    {dots, _} = Agent.get(__MODULE__, &(&1))
    dots
  end

  @doc """
  Get the count of all dots that ever existed.
  """
  def get_count do
    {_, count} = Agent.get(__MODULE__, &(&1))
    count
  end

  def put_new_dot(dot) do
    new_count = get_count() + 1
    new_dot_id = Integer.to_string(new_count)
    Agent.update(__MODULE__, fn({map, _}) ->
      {Map.put_new(map, new_dot_id, dot), new_count}
    end)
    %{new_dot_id => dot}
  end

  def delete_dot(dot_id) do
    Agent.update(__MODULE__, fn({map, count}) ->
      {Map.delete(map, dot_id), count}
    end)
    dot_id
  end
end
