defmodule LiquidDots.PageController do
  use LiquidDots.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
