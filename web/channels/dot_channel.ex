defmodule LiquidDots.DotChannel do
  use Phoenix.Channel
  alias LiquidDots.DotState

  def join("dots", _message, socket) do
    current_dots = DotState.get_dots()
    {:ok, %{"dots": current_dots}, socket}
  end

  def handle_in("dot:add", %{"new_dot_data" => new_dot_data}, socket) do
    broadcast! socket, "dot:added", %{new_dot: DotState.put_new_dot(new_dot_data)}
    {:noreply, socket}
  end

  def handle_in("dot:delete", %{"dot_id" => dot_id}, socket) do
    broadcast! socket, "dot:deleted", %{dot_id: DotState.delete_dot(dot_id)}
    {:noreply, socket}
  end
end
