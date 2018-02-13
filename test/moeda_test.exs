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
end
