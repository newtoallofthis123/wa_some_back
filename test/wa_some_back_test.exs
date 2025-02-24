defmodule WaSomeBackTest do
  use ExUnit.Case
  doctest WaSomeBack

  test "greets the world" do
    assert WaSomeBack.hello() == :world
  end
end
