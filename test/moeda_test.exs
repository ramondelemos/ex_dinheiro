defmodule MoedaTest do
  use ExUnit.Case
  doctest Moeda

  test "find/1" do
    assert Moeda.find("BRL") == %{
             nome: "Brazilian Real",
             simbolo: 'R$',
             codigo: "BRL",
             codigo_iso: 986,
             expoente: 2
           }

    assert Moeda.find("brl") == %{
             nome: "Brazilian Real",
             simbolo: 'R$',
             codigo: "BRL",
             codigo_iso: 986,
             expoente: 2
           }

    assert Moeda.find(:BRL) == %{
             nome: "Brazilian Real",
             simbolo: 'R$',
             codigo: "BRL",
             codigo_iso: 986,
             expoente: 2
           }

    assert Moeda.find(:brl) == %{
             nome: "Brazilian Real",
             simbolo: 'R$',
             codigo: "BRL",
             codigo_iso: 986,
             expoente: 2
           }

    assert Moeda.find("CNY") == %{
             nome: "Yuan Renminbi",
             simbolo: [165],
             codigo: "CNY",
             codigo_iso: 156,
             expoente: 2
           }

    assert Moeda.find(:chf) == %{
             nome: "Swiss Franc",
             simbolo: [67, 72, 70],
             codigo: "CHF",
             codigo_iso: 756,
             expoente: 2
           }

    assert Moeda.find(:CHW) == %{
             nome: "WIR Franc",
             simbolo: [],
             codigo: "CHW",
             codigo_iso: 948,
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
    assert Moeda.get_atom(:CLF) == :CLF
    assert Moeda.get_atom("PYG") == :PYG
    assert Moeda.get_atom(:CHW) == :CHW
  end

  test "get_factor/1" do
    assert Moeda.get_factor("BRL") == 100.0
    assert Moeda.get_factor("brl") == 100.0
    assert Moeda.get_factor(:BRL) == 100.0
    assert Moeda.get_factor(:brl) == 100.0
    assert Moeda.get_factor("") == nil
    assert Moeda.get_factor(:CLF) == 10000.0
    assert Moeda.get_factor(:PYG) == 1.0
    assert Moeda.get_factor(:IQD) == 1000.0
  end

  test "to_string/3" do
    assert Moeda.to_string(:BRL, 0.1) == "R$ 0,10"
    assert Moeda.to_string("BRL", 1.0) == "R$ 1,00"
    assert Moeda.to_string("brl", 10.0) == "R$ 10,00"
    assert Moeda.to_string(:BRL, 100.0) == "R$ 100,00"
    assert Moeda.to_string(:IRR, 200.0) == "﷼ 200,00"
    assert Moeda.to_string(:UGX, 300.0) == "300"
    assert Moeda.to_string(:MKD, 400.0) == "ден 400,00"
    assert Moeda.to_string(:JPY, 500.1) == "¥ 500"
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
