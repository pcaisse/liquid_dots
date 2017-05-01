defmodule LiquidDots.DotState do
  @moduledoc """
  Keep track of dot state (position and color).
  """

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get_dots do
    Agent.get(__MODULE__, &(&1))
  end

  def put_new_dot(dot) do
    dots = get_dots()
    num_dots = map_size(dots)
    new_dot_id = String.to_atom(to_string(num_dots + 1))
    Agent.update(__MODULE__, &Map.put_new(&1, new_dot_id, dot))
    %{new_dot_id => dot}
  end

  def delete_dot(dot_id) do
    Agent.update(__MODULE__, &Map.delete(&1, dot_id))
  end
end
