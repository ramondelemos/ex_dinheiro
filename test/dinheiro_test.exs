defmodule DinheiroTest do
  use ExUnit.Case
  doctest Dinheiro

  test "new/1 with default value set" do
    try do
      Application.put_env(:ex_dinheiro, :default_moeda, :BRL)
      assert Dinheiro.new(12345) == %Dinheiro{ quantia: 1234500, moeda: :BRL }
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

  test "new/1 with float value" do 
    
    try do
      Application.put_env(:ex_dinheiro, :default_moeda, :BRL)
      assert Dinheiro.new(123.45) == %Dinheiro{ quantia: 12345, moeda: :BRL }
    after
      Application.delete_env(:ex_dinheiro, :default_moeda)
    end
  end

  test "new/1 with an invalid value" do

    try do
      Application.put_env(:ex_dinheiro, :default_moeda, :BRL)
      assert_raise FunctionClauseError, fn ->
        Dinheiro.new("1234")
      end
    after
      Application.delete_env(:ex_dinheiro, :default_moeda)
    end
  end

  test "new/2 with a float value" do
    assert Dinheiro.new(123.45, :BRL) == %Dinheiro{ quantia: 12345, moeda: :BRL }
  end

  test "new/2 with an invalid value" do
    assert_raise FunctionClauseError, fn ->
      Dinheiro.new("12345", :BRL)
    end
  end

  test "compare/1" do
    assert Dinheiro.compare(Dinheiro.new(123.45, :BRL), %Dinheiro{ quantia: 12345, moeda: :BRL }) == 0
    assert Dinheiro.compare(Dinheiro.new(123.45, :BRL), %Dinheiro{ quantia: 12346, moeda: :BRL }) == -1
    assert Dinheiro.compare(Dinheiro.new(123.46, :BRL), %Dinheiro{ quantia: 12345, moeda: :BRL }) == 1
    assert_raise ArgumentError, fn ->
      Dinheiro.compare(Dinheiro.new(123.45, :BRL), %Dinheiro{ quantia: 12345, moeda: :USD }) == 0
    end
  end

  test "sum/2" do
    assert Dinheiro.sum(Dinheiro.new(12345, :BRL), Dinheiro.new(12345, :BRL)) == %Dinheiro{ quantia: 2469000, moeda: :BRL }
    assert Dinheiro.sum(Dinheiro.new(1, :BRL), 1) == %Dinheiro{ quantia: 200, moeda: :BRL }
    assert Dinheiro.sum(Dinheiro.new(1, :BRL), 1.2) == %Dinheiro{ quantia: 220, moeda: :BRL }
    assert Dinheiro.sum(Dinheiro.new(-1, :BRL), 1.2) == %Dinheiro{ quantia: 20, moeda: :BRL }
    assert_raise ArgumentError, fn ->
      Dinheiro.sum(Dinheiro.new(1, :BRL), Dinheiro.new(1, :USD))
    end
  end

  test "subtract/2" do
    assert Dinheiro.subtract(Dinheiro.new(2, :BRL), Dinheiro.new(1, :BRL)) == %Dinheiro{ quantia: 100, moeda: :BRL }
    assert Dinheiro.subtract(Dinheiro.new(3, :BRL), 1) == %Dinheiro{ quantia: 200, moeda: :BRL }
    assert Dinheiro.subtract(Dinheiro.new(4, :BRL), 1.2) == %Dinheiro{ quantia: 280, moeda: :BRL }
    assert Dinheiro.subtract(Dinheiro.new(1, :BRL), -1) == %Dinheiro{ quantia: 200, moeda: :BRL }
    assert_raise ArgumentError, fn ->
      Dinheiro.subtract(Dinheiro.new(2, :BRL), Dinheiro.new(1, :USD))
    end
  end

end
