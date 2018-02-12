defmodule DinheiroTest do
  use ExUnit.Case
  doctest Dinheiro

  test "new/1 with default value set" do
    try do
      Application.put_env(:ex_dinheiro, :default_moeda, :BRL)
      assert Dinheiro.new(12345) == Dinheiro.new(12345, :BRL)
    after
      Application.delete_env(:ex_dinheiro, :default_moeda)
    end
  end

  test "new/1 with an invalid default value set" do
    try do
      Application.put_env(:ex_dinheiro, :default_moeda, :NONE)
      assert_raise ArgumentError, fn ->
        Dinheiro.new(12345)
      end
    after
      Application.delete_env(:ex_dinheiro, :default_moeda)
    end
  end

  test "new/1 with no config set" do
    assert_raise ArgumentError, fn ->
      Dinheiro.new(12345)
    end
  end

  test "new/2 requires existing value" do
    assert_raise ArgumentError, fn ->
      Dinheiro.new(12345, :NONE)
    end
  end
end
