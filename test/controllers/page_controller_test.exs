defmodule LiquidDots.PageControllerTest do
  use LiquidDots.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "LiquidDots"
  end
end
