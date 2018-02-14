defmodule MoedaTest do
  use ExUnit.Case
  doctest Moeda

  test "find/1" do
    assert Moeda.find("BRL") == %{
             nome: "Brazilian Real",
             simbolo: "R$",
             codigo: "BRL",
             codigo_iso: 986,
             expoente: 2
           }

    assert Moeda.find("brl") == %{
             nome: "Brazilian Real",
             simbolo: "R$",
             codigo: "BRL",
             codigo_iso: 986,
             expoente: 2
           }

    assert Moeda.find(:BRL) == %{
             nome: "Brazilian Real",
             simbolo: "R$",
             codigo: "BRL",
             codigo_iso: 986,
             expoente: 2
           }

    assert Moeda.find(:brl) == %{
             nome: "Brazilian Real",
             simbolo: "R$",
             codigo: "BRL",
             codigo_iso: 986,
             expoente: 2
           }

    assert Moeda.find("") == nil
  end

  test "get_atom/1" do
    assert Moeda.get_atom("BRL") == :BRL
    assert Moeda.get_atom("brl") == :BRL
    assert Moeda.get_atom(:BRL) == :BRL
    assert Moeda.get_atom(:brl) == :BRL
    assert Moeda.get_atom("") == nil
  end

  test "get_factor/1" do
    assert Moeda.get_factor("BRL") == 100.0
    assert Moeda.get_factor("brl") == 100.0
    assert Moeda.get_factor(:BRL) == 100.0
    assert Moeda.get_factor(:brl) == 100.0
    assert Moeda.get_factor("") == nil
  end

  test "to_string/3" do
    assert Moeda.to_string(:BRL, 0.1) == "R$ 0,10"
    assert Moeda.to_string("BRL", 1.0) == "R$ 1,00"
    assert Moeda.to_string("brl", 10.0) == "R$ 10,00"
    assert Moeda.to_string(:BRL, 100.0) == "R$ 100,00"
    assert Moeda.to_string(:BRL, -1000.0) == "R$ -1.000,00"
    assert Moeda.to_string(:brl, 12_345_678.9) == "R$ 12.345.678,90"

    assert Moeda.to_string(:USD, 12_345_678.9, thousand_separator: ",", decimal_separator: ".") ==
             "$ 12,345,678.90"

    assert_raise ArgumentError, fn ->
      Moeda.to_string(:BRL, 100)
    end

    assert_raise ArgumentError, fn ->
      Moeda.to_string(:NONE, 100.0)
    end

    assert_raise ArgumentError, fn ->
      Moeda.to_string("NONE", 100.0)
    end
  end
end
