defmodule MoedaTest do
  use ExUnit.Case
  doctest Moeda

  setup_all do
    moedas = %{
      XBT: %Moeda{
        nome: "Bitcoin",
        simbolo: '฿',
        codigo: "XBT",
        codigo_iso: 0,
        expoente: 8
      },
      BRL: %Moeda{
        nome: "Moeda do Brasil",
        simbolo: 'BR$',
        codigo: "BRL",
        codigo_iso: 986,
        expoente: 4
      },
      USD: %Moeda{
        nome: "Moeda do EUA",
        simbolo: 'US$',
        codigo: "USD",
        codigo_iso: 986,
        expoente: 3
      }
    }

    {:ok, %{moedas: moedas}}
  end

  setup do
    Application.delete_env(:ex_dinheiro, :thousand_separator)
    Application.delete_env(:ex_dinheiro, :decimal_separator)
    Application.delete_env(:ex_dinheiro, :display_currency_symbol)
    Application.delete_env(:ex_dinheiro, :display_currency_code)
    Application.delete_env(:ex_dinheiro, :unofficial_currencies)
  end

  test "find!/1" do
    assert Moeda.find("BRL") == %Moeda{
             nome: "Brazilian Real",
             simbolo: 'R$',
             codigo: "BRL",
             codigo_iso: 986,
             expoente: 2
           }

    assert_raise ArgumentError, fn ->
      Moeda.find!(:NONE)
    end
  end

  test "find/1", context do
    assert Moeda.find("BRL") == %Moeda{
             nome: "Brazilian Real",
             simbolo: 'R$',
             codigo: "BRL",
             codigo_iso: 986,
             expoente: 2
           }

    assert Moeda.find("brl") == %Moeda{
             nome: "Brazilian Real",
             simbolo: 'R$',
             codigo: "BRL",
             codigo_iso: 986,
             expoente: 2
           }

    assert Moeda.find(:BRL) == %Moeda{
             nome: "Brazilian Real",
             simbolo: 'R$',
             codigo: "BRL",
             codigo_iso: 986,
             expoente: 2
           }

    assert Moeda.find(:brl) == %Moeda{
             nome: "Brazilian Real",
             simbolo: 'R$',
             codigo: "BRL",
             codigo_iso: 986,
             expoente: 2
           }

    assert Moeda.find("CNY") == %Moeda{
             nome: "Yuan Renminbi",
             simbolo: [165],
             codigo: "CNY",
             codigo_iso: 156,
             expoente: 2
           }

    assert Moeda.find(:chf) == %Moeda{
             nome: "Swiss Franc",
             simbolo: [67, 72, 70],
             codigo: "CHF",
             codigo_iso: 756,
             expoente: 2
           }

    assert Moeda.find(:CHW) == %Moeda{
             nome: "WIR Franc",
             simbolo: [],
             codigo: "CHW",
             codigo_iso: 948,
             expoente: 2
           }

    assert Moeda.find("") == nil

    Application.put_env(:ex_dinheiro, :unofficial_currencies, context[:moedas])

    assert Moeda.find(:BRL) == %Moeda{
             nome: "Moeda do Brasil",
             simbolo: 'BR$',
             codigo: "BRL",
             codigo_iso: 986,
             expoente: 4
           }

    assert Moeda.find(:usd) == %Moeda{
             nome: "Moeda do EUA",
             simbolo: 'US$',
             codigo: "USD",
             codigo_iso: 986,
             expoente: 3
           }

    assert Moeda.find("XBT") == %Moeda{
             nome: "Bitcoin",
             simbolo: '฿',
             codigo: "XBT",
             codigo_iso: 0,
             expoente: 8
           }
  end

  test "get_atom/1", context do
    assert Moeda.get_atom("BRL") == :BRL
    assert Moeda.get_atom("brl") == :BRL
    assert Moeda.get_atom(:BRL) == :BRL
    assert Moeda.get_atom(:brl) == :BRL
    assert Moeda.get_atom("") == nil
    assert Moeda.get_atom(:CLF) == :CLF
    assert Moeda.get_atom("PYG") == :PYG
    assert Moeda.get_atom(:CHW) == :CHW

    Application.put_env(:ex_dinheiro, :unofficial_currencies, context[:moedas])

    assert Moeda.get_atom(:BRL) == :BRL
    assert Moeda.get_atom("XBT") == :XBT
    assert Moeda.get_atom(:usd) == :USD
  end

  test "get_factor/1", context do
    assert Moeda.get_factor("BRL") == 100.0
    assert Moeda.get_factor("brl") == 100.0
    assert Moeda.get_factor(:BRL) == 100.0
    assert Moeda.get_factor(:brl) == 100.0
    assert Moeda.get_factor("") == nil
    assert Moeda.get_factor(:CLF) == 10_000.0
    assert Moeda.get_factor(:PYG) == 1.0
    assert Moeda.get_factor(:IQD) == 1_000.0

    Application.put_env(:ex_dinheiro, :unofficial_currencies, context[:moedas])

    assert Moeda.get_factor(:BRL) == 10_000.0
    assert Moeda.get_factor("XBT") == 100_000_000.0
    assert Moeda.get_factor(:usd) == 1_000.0
  end

  test "to_string/3" do
    assert Moeda.to_string(:BRL, 100.0) == {:ok, "R$ 100,00"}

    assert Moeda.to_string(:NONE, 1000.5) ==
             {:error, "'NONE' does not represent an ISO 4217 code."}
  end

  test "to_string!/3" do
    assert Moeda.to_string!(:BRL, 0.1) == "R$ 0,10"
    assert Moeda.to_string!("BRL", 1.0) == "R$ 1,00"
    assert Moeda.to_string!("brl", 10.0) == "R$ 10,00"
    assert Moeda.to_string!(:BRL, 100.0) == "R$ 100,00"
    assert Moeda.to_string!(:IRR, 200.0) == "﷼ 200,00"
    assert Moeda.to_string!(:UGX, 300.0) == "300"
    assert Moeda.to_string!(:MKD, 400.0) == "ден 400,00"
    assert Moeda.to_string!(:JPY, 500.1) == "¥ 500"
    assert Moeda.to_string!(:BRL, -1_000.0) == "R$ -1.000,00"
    assert Moeda.to_string!(:brl, 12_345_678.9) == "R$ 12.345.678,90"

    assert Moeda.to_string!(
             :USD,
             12_345_678.9,
             thousand_separator: ",",
             decimal_separator: "."
           ) == "$ 12,345,678.90"

    assert Moeda.to_string!(:BRL, 12_345_678.9, display_currency_symbol: false) ==
             "12.345.678,90"

    assert Moeda.to_string!(:BRL, 12_345_678.9, display_currency_code: true) ==
             "R$ 12.345.678,90 BRL"

    assert_raise ArgumentError, fn ->
      Moeda.to_string!(:BRL, 100)
    end

    assert_raise ArgumentError, fn ->
      Moeda.to_string!(:NONE, 100.0)
    end

    assert_raise ArgumentError, fn ->
      Moeda.to_string!("NONE", 100.0)
    end
  end

  test "to_string!/3 with changes in the system Mix config." do
    assert Moeda.to_string!(:BRL, 12_345_678.9) == "R$ 12.345.678,90"

    Application.put_env(:ex_dinheiro, :thousand_separator, ",")
    Application.put_env(:ex_dinheiro, :decimal_separator, ".")

    assert Moeda.to_string!(:USD, 12_345_678.9) == "$ 12,345,678.90"

    assert Moeda.to_string!(
             :USD,
             12_345_678.9,
             thousand_separator: "_",
             decimal_separator: "*"
           ) == "$ 12_345_678*90"

    Application.put_env(:ex_dinheiro, :display_currency_symbol, false)

    assert Moeda.to_string!(:USD, 12_345_678.9) == "12,345,678.90"

    Application.put_env(:ex_dinheiro, :display_currency_code, true)

    assert Moeda.to_string!(:USD, 12_345_678.9) == "12,345,678.90 USD"

    assert Moeda.to_string!(
             :BRL,
             12_345_678.9,
             thousand_separator: "_",
             decimal_separator: "*",
             display_currency_code: false,
             display_currency_symbol: true
           ) == "R$ 12_345_678*90"
  end

  test "to_string!/3 with new currencies in the system Mix config.", context do
    Application.put_env(:ex_dinheiro, :unofficial_currencies, context[:moedas])
    assert Moeda.to_string!(:BRL, 12_345_678.9) == "BR$ 12.345.678,9000"
    assert Moeda.to_string!(:usd, 12_345_678.9) == "US$ 12.345.678,900"
    assert Moeda.to_string!("XBT", 12_345_678.9) == "฿ 12.345.678,90000000"
  end

  test "Não vai subir ninguém!" do
    assert false
  end
end
