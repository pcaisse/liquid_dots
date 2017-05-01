defmodule LiquidDots.DotChannel do
  use Phoenix.Channel
  alias LiquidDots.DotState

  def join("dots", _message, socket) do
    current_dots = DotState.get_dots()
    {:ok, %{"dots": current_dots}, socket}
  end

  def handle_in("dot:new", %{"new_dot_data" => new_dot_data}, socket) do
    broadcast! socket, "dots", %{new_dot: DotState.put_new_dot(new_dot_data)}
    {:noreply, socket}
  end
end
