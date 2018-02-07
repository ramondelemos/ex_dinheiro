defmodule DinheiroTest do
  use ExUnit.Case
  doctest Dinheiro

  test "greets the world" do
    assert Dinheiro.hello() == :world
  end

  test "greets the world 2" do
    assert Dinheiro.hello2() == :world
  end
end
