defmodule LiquidDots.DotStateTest do
  use ExUnit.Case, async: true
  alias LiquidDots.DotState

  setup do
    {:ok, agent} = DotState.start_link(:test, %{"1" => "foo"})
    {:ok, agent: agent}
  end

  test "dot state", %{agent: agent} do
    assert DotState.get_dots(agent) == %{"1" => "foo"}

    expected = %{"2" => "bar"}
    assert DotState.put_new_dot(agent, "bar") == expected

    DotState.delete_dot(agent, "1")
    assert DotState.get_dots(agent) == expected
  end
end
