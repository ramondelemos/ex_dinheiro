defmodule MoedaTest do
  use ExUnit.Case
  doctest Moeda

  setup_all do
    currencies = %{
      XBT: %Moeda{
        name: "Bitcoin",
        symbol: '฿',
        alpha_code: "XBT",
        num_code: 0,
        exponent: 8
      },
      BRL: %Moeda{
        name: "Moeda do Brasil",
        symbol: 'BR$',
        alpha_code: "BRL",
        num_code: 986,
        exponent: 4
      },
      USD: %Moeda{
        name: "Moeda do EUA",
        symbol: 'US$',
        alpha_code: "USD",
        num_code: 986,
        exponent: 3
      }
    }

    {:ok, %{currencies: currencies}}
  end

  setup do
    Application.delete_env(:ex_dinheiro, :thousand_separator)
    Application.delete_env(:ex_dinheiro, :decimal_separator)
    Application.delete_env(:ex_dinheiro, :display_currency_symbol)
    Application.delete_env(:ex_dinheiro, :display_currency_code)
    Application.delete_env(:ex_dinheiro, :unofficial_currencies)
  end

  test "find!/1" do
    assert Moeda.find!("BRL") == %Moeda{
             name: "Brazilian Real",
             symbol: 'R$',
             alpha_code: "BRL",
             num_code: 986,
             exponent: 2
           }

    assert_raise ArgumentError, fn ->
      Moeda.find!(:NONE)
    end
  end

  test "find/1", context do
    assert Moeda.find("BRL") ==
             {:ok,
              %Moeda{
                name: "Brazilian Real",
                symbol: 'R$',
                alpha_code: "BRL",
                num_code: 986,
                exponent: 2
              }}

    assert Moeda.find("brl") ==
             {:ok,
              %Moeda{
                name: "Brazilian Real",
                symbol: 'R$',
                alpha_code: "BRL",
                num_code: 986,
                exponent: 2
              }}

    assert Moeda.find(:BRL) ==
             {:ok,
              %Moeda{
                name: "Brazilian Real",
                symbol: 'R$',
                alpha_code: "BRL",
                num_code: 986,
                exponent: 2
              }}

    assert Moeda.find(:brl) ==
             {:ok,
              %Moeda{
                name: "Brazilian Real",
                symbol: 'R$',
                alpha_code: "BRL",
                num_code: 986,
                exponent: 2
              }}

    assert Moeda.find(986) ==
             {:ok,
              %Moeda{
                name: "Brazilian Real",
                symbol: 'R$',
                alpha_code: "BRL",
                num_code: 986,
                exponent: 2
              }}

    assert Moeda.find("CNY") ==
             {:ok,
              %Moeda{
                name: "Yuan Renminbi",
                symbol: [165],
                alpha_code: "CNY",
                num_code: 156,
                exponent: 2
              }}

    assert Moeda.find(:chf) ==
             {:ok,
              %Moeda{
                name: "Swiss Franc",
                symbol: [67, 72, 70],
                alpha_code: "CHF",
                num_code: 756,
                exponent: 2
              }}

    assert Moeda.find(:CHW) ==
             {:ok,
              %Moeda{
                name: "WIR Franc",
                symbol: [],
                alpha_code: "CHW",
                num_code: 948,
                exponent: 2
              }}

    assert Moeda.find(:NONE) ==
             {:error, "'NONE' does not represent an ISO 4217 code"}

    Application.put_env(
      :ex_dinheiro,
      :unofficial_currencies,
      context[:currencies]
    )

    assert Moeda.find(:BRL) ==
             {:ok,
              %Moeda{
                name: "Moeda do Brasil",
                symbol: 'BR$',
                alpha_code: "BRL",
                num_code: 986,
                exponent: 4
              }}

    assert Moeda.find(:usd) ==
             {:ok,
              %Moeda{
                name: "Moeda do EUA",
                symbol: 'US$',
                alpha_code: "USD",
                num_code: 986,
                exponent: 3
              }}

    assert Moeda.find("XBT") ==
             {:ok,
              %Moeda{
                name: "Bitcoin",
                symbol: '฿',
                alpha_code: "XBT",
                num_code: 0,
                exponent: 8
              }}
  end

  test "get_atom/1" do
    assert Moeda.get_atom("BRL") == {:ok, :BRL}

    assert Moeda.get_atom("NONE") ==
             {:error, "'NONE' does not represent an ISO 4217 code"}
  end

  test "get_atom!/1", context do
    assert Moeda.get_atom!("BRL") == :BRL
    assert Moeda.get_atom!("brl") == :BRL
    assert Moeda.get_atom!(:BRL) == :BRL
    assert Moeda.get_atom!(:brl) == :BRL

    assert_raise ArgumentError, fn ->
      Moeda.get_atom!("")
    end

    assert Moeda.get_atom!(:CLF) == :CLF
    assert Moeda.get_atom!("PYG") == :PYG
    assert Moeda.get_atom!(:CHW) == :CHW

    Application.put_env(
      :ex_dinheiro,
      :unofficial_currencies,
      context[:currencies]
    )

    assert Moeda.get_atom!(:BRL) == :BRL
    assert Moeda.get_atom!("XBT") == :XBT
    assert Moeda.get_atom!(:usd) == :USD
  end

  test "get_factor/1" do
    assert Moeda.get_factor("BRL") == {:ok, 100.0}

    assert Moeda.get_factor(:NONE) ==
             {:error, "'NONE' does not represent an ISO 4217 code"}
  end

  test "get_factor!/1", context do
    assert Moeda.get_factor!("BRL") == 100.0
    assert Moeda.get_factor!("brl") == 100.0
    assert Moeda.get_factor!(:BRL) == 100.0
    assert Moeda.get_factor!(:brl) == 100.0

    assert_raise ArgumentError, fn ->
      Moeda.get_factor!("")
    end

    assert Moeda.get_factor!(:CLF) == 10_000.0
    assert Moeda.get_factor!(:PYG) == 1.0
    assert Moeda.get_factor!(:IQD) == 1_000.0

    Application.put_env(
      :ex_dinheiro,
      :unofficial_currencies,
      context[:currencies]
    )

    assert Moeda.get_factor!(:BRL) == 10_000.0
    assert Moeda.get_factor!("XBT") == 100_000_000.0
    assert Moeda.get_factor!(:usd) == 1_000.0
  end

  test "to_string/3" do
    assert Moeda.to_string(:BRL, 100.0) == {:ok, "R$ 100,00"}

    assert Moeda.to_string(:NONE, 1000.5) ==
             {:error, "'NONE' does not represent an ISO 4217 code"}
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
    Application.put_env(
      :ex_dinheiro,
      :unofficial_currencies,
      context[:currencies]
    )

    assert Moeda.to_string!(:BRL, 12_345_678.9) == "BR$ 12.345.678,9000"
    assert Moeda.to_string!(:usd, 12_345_678.9) == "US$ 12.345.678,900"
    assert Moeda.to_string!("XBT", 12_345_678.9) == "฿ 12.345.678,90000000"
  end
end
