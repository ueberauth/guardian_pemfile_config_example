defmodule DebugGuardianTest do
  use ExUnit.Case
  doctest DebugGuardian

  test "greets the world" do
    assert DebugGuardian.hello() == :world
  end
end
