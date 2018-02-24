defmodule Moeda do
  @moduledoc """

  [![Build Status](https://travis-ci.org/ramondelemos/ex_dinheiro.svg?branch=master)](https://travis-ci.org/ramondelemos/ex_dinheiro?branch=master)
  [![Coverage Status](https://coveralls.io/repos/github/ramondelemos/ex_dinheiro/badge.svg?branch=master)](https://coveralls.io/github/ramondelemos/ex_dinheiro?branch=master)

  """

  alias Moeda.Moedas

  defstruct [:nome, :simbolo, :codigo, :codigo_iso, :expoente]

  @typedoc """
      Type that represents `Moeda` struct with:
      :nome as String.t that represents the name of the currency.
      :simbolo as String.t that represents symbol of the currency.
      :codigo as String.t that represents the ISO 4217 code.
      :codigo_iso as integer that represents the country code.
      :expoente as integer that represents the exponent of the currency.
  """
  @type t :: %Moeda{
          nome: String.t(),
          simbolo: String.t(),
          codigo: String.t(),
          codigo_iso: integer,
          expoente: integer
        }

  @spec find!(String.t() | atom) :: t
  @doc """
  Return a map from an atom or string that represents an ISO 4217 code.

  ## Examples

      iex> Moeda.find!(:BRL)
      %Moeda{nome: "Brazilian Real", simbolo: 'R$', codigo: "BRL", codigo_iso: 986, expoente: 2}
      iex> Moeda.find!(:NONE)
      ** (ArgumentError) 'NONE' does not represent an ISO 4217 code.
  """
  def find!(codigo) when is_atom(codigo) or is_binary(codigo) do
    case find(codigo) do
      {:ok, value} -> value
      {:error, reason} -> raise ArgumentError, message: reason
    end
  end

  @spec find(String.t() | atom) :: {:ok, t} | {:error, String.t()}
  @doc """
  Return a map from an atom or string that represents an ISO 4217 code.

  ## Examples

      iex> Moeda.find(:BRL)
      {:ok, %Moeda{nome: "Brazilian Real", simbolo: 'R$', codigo: "BRL", codigo_iso: 986, expoente: 2}}
      iex> Moeda.find("BRL")
      {:ok, %Moeda{nome: "Brazilian Real", simbolo: 'R$', codigo: "BRL", codigo_iso: 986, expoente: 2}}
      iex> Moeda.find("NONE")
      {:error, "'NONE' does not represent an ISO 4217 code."}

  Its function ignore case sensitive.

  ## Examples

      iex> Moeda.find(:brl)
      {:ok, %Moeda{nome: "Brazilian Real", simbolo: 'R$', codigo: "BRL", codigo_iso: 986, expoente: 2}}
      iex> Moeda.find("brl")
      {:ok, %Moeda{nome: "Brazilian Real", simbolo: 'R$', codigo: "BRL", codigo_iso: 986, expoente: 2}}

  Is possible to work with no official ISO currency code adding it in the system Mix config.

  ## Examples

      iex> Moeda.find(:XBT)
      {:error, "'XBT' does not represent an ISO 4217 code."}
      iex> moedas = %{ XBT: %Moeda{nome: "Bitcoin", simbolo: '฿', codigo: "XBT", codigo_iso: 0, expoente: 8} }
      iex> Application.put_env(:ex_dinheiro, :unofficial_currencies, moedas)
      iex> Moeda.find("xbt")
      {:ok, %Moeda{nome: "Bitcoin", simbolo: '฿', codigo: "XBT", codigo_iso: 0, expoente: 8}}

  Is possible to override some official ISO currency code adding it in the system Mix config.

  ## Examples

      iex> Moeda.find(:BRL)
      {:ok, %Moeda{nome: "Brazilian Real", simbolo: 'R$', codigo: "BRL", codigo_iso: 986, expoente: 2}}
      iex> moedas = %{ BRL: %Moeda{nome: "Moeda do Brasil", simbolo: 'BR$', codigo: "BRL", codigo_iso: 986, expoente: 4}, USD: %Moeda{nome: "Moeda do EUA", simbolo: 'US$', codigo: "USD", codigo_iso: 986, expoente: 3} }
      iex> Application.put_env(:ex_dinheiro, :unofficial_currencies, moedas)
      iex> Moeda.find(:BRL)
      {:ok, %Moeda{nome: "Moeda do Brasil", simbolo: 'BR$', codigo: "BRL", codigo_iso: 986, expoente: 4}}
      iex> Moeda.find(:USD)
      {:ok, %Moeda{nome: "Moeda do EUA", simbolo: 'US$', codigo: "USD", codigo_iso: 986, expoente: 3}}

  """
  def find(codigo) when is_atom(codigo) do
    codigo
    |> Atom.to_string()
    |> String.upcase()
    |> String.to_atom()
    |> do_find
  end

  def find(codigo) when is_binary(codigo) do
    codigo
    |> String.upcase()
    |> String.to_atom()
    |> do_find
  end

  defp do_find(codigo) do
    unofficial_currencies =
      Application.get_env(:ex_dinheiro, :unofficial_currencies, %{})

    currency = unofficial_currencies[codigo]

    if currency do
      wrap_up_moeda(currency, codigo)
    else
      currencies = Moedas.get_moedas()
      wrap_up_moeda(currencies[codigo], codigo)
    end
  end

  defp wrap_up_moeda(moeda, codigo) do
    if (moeda) do
      {:ok, moeda}
    else
      {:error, "'#{codigo}' does not represent an ISO 4217 code."}
    end
  end

  @spec get_atom(String.t() | atom) :: atom | nil
  @doc """
  Return an atom from a value that represents an ISO 4217 code.

  ## Examples

      iex> Moeda.get_atom(:BRL)
      :BRL
      iex> Moeda.get_atom("BRL")
      :BRL
      iex> Moeda.get_atom("")
      nil

  Its function ignore case sensitive.

  ## Examples

      iex> Moeda.get_atom(:brl)
      :BRL
      iex> Moeda.get_atom("brl")
      :BRL

  """
  def get_atom(codigo) do
    moeda = find!(codigo)

    if moeda do
      moeda.codigo |> String.upcase() |> String.to_atom()
    else
      nil
    end
  end

  @spec get_factor(String.t() | atom) :: float | nil
  @doc """
  Return a multiplication factor from an ISO 4217 code.

  ## Examples

      iex> Moeda.get_factor(:BRL)
      100.0
      iex> Moeda.get_factor("BRL")
      100.0
      iex> Moeda.get_factor("")
      nil

  Its function ignore case sensitive.

  ## Examples

      iex> Moeda.get_factor(:brl)
      100.0
      iex> Moeda.get_factor("brl")
      100.0

  """
  def get_factor(codigo) do
    moeda = find!(codigo)

    if moeda do
      :math.pow(10, moeda.expoente)
    else
      nil
    end
  end

  @spec to_string(String.t() | atom, float, Keywords.t()) ::
          {:ok, String.t()} | {:error, String.t()}
  @doc """
  Return a formated string from a ISO 4217 code and a float value.

  ## Examples

      iex> Moeda.to_string(:BRL, 100.0)
      {:ok, "R$ 100,00"}
      iex> Moeda.to_string(:NONE, 1000.5)
      {:error, "'NONE' does not represent an ISO 4217 code."}
  """
  def to_string(moeda, valor, opts \\ []) do
    try do
      {:ok, to_string!(moeda, valor, opts)}
    rescue
      e -> {:error, e.message}
    end
  end

  @spec to_string!(String.t() | atom, float, Keywords.t()) :: String.t()
  @doc """
  Return a formated string from a ISO 4217 code and a float value.

  ## Examples

      iex> Moeda.to_string!(:BRL, 100.0)
      "R$ 100,00"
      iex> Moeda.to_string!("BRL", 1000.5)
      "R$ 1.000,50"
      iex> Moeda.to_string!(:BRL, -1.0)
      "R$ -1,00"

  Its function ignore case sensitive.

  ## Examples

      iex> Moeda.to_string!(:bRl, 100.0)
      "R$ 100,00"
      iex> Moeda.to_string!("BrL", 1000.5)
      "R$ 1.000,50"

  Using options-style parameters you can change the behavior of the function.

    - `thousand_separator` - default `"."`, set the thousand separator.
    - `decimal_separator` - default `","`, set the decimal separator.
    - `display_currency_symbol` - default `true`, put to `false` to hide de currency symbol.
    - `display_currency_code` - default `false`, put to `true` to display de currency ISO 4217 code.

  ## Exemples

      iex> Moeda.to_string!(:USD, 1000.5, thousand_separator: ",", decimal_separator: ".")
      "$ 1,000.50"
      iex> Moeda.to_string!(:USD, 1000.5, display_currency_symbol: false)
      "1.000,50"
      iex> Moeda.to_string!(:USD, 1000.5, display_currency_code: true)
      "$ 1.000,50 USD"
      iex> Moeda.to_string!(:USD, 1000.5, display_currency_code: true, display_currency_symbol: false)
      "1.000,50 USD"

  The default values also can be set in the system Mix config.

  ## Example:
      iex> Application.put_env(:ex_dinheiro, :thousand_separator, ",")
      iex> Application.put_env(:ex_dinheiro, :decimal_separator, ".")
      iex> Moeda.to_string!(:USD, 1000.5)
      "$ 1,000.50"
      iex> Application.put_env(:ex_dinheiro, :display_currency_symbol, false)
      iex> Moeda.to_string!(:USD, 5000.5)
      "5,000.50"
      iex> Application.put_env(:ex_dinheiro, :display_currency_code, true)
      iex> Moeda.to_string!(:USD, 10000.0)
      "10,000.00 USD"

  The options-style parameters override values in the system Mix config.

  ## Example:
      iex> Application.put_env(:ex_dinheiro, :thousand_separator, ",")
      iex> Application.put_env(:ex_dinheiro, :decimal_separator, ".")
      iex> Moeda.to_string!(:USD, 1000.5)
      "$ 1,000.50"
      iex> Moeda.to_string!(:BRL, 1000.5, thousand_separator: ".", decimal_separator: ",")
      "R$ 1.000,50"

  """
  def to_string!(moeda, valor, opts \\ []) do
    m = find!(moeda)

    unless is_float(valor),
      do: raise(ArgumentError, message: "Value '#{valor}' must be float.")

    {thousand_separator, decimal_separator, display_currency_symbol,
     display_currency_code} = get_config(opts)

    parts =
      valor
      |> :erlang.float_to_binary(decimals: m.expoente)
      |> String.split(".")

    thousands =
      parts
      |> List.first()
      |> String.reverse()
      |> String.codepoints()
      |> format_thousands(thousand_separator)
      |> String.reverse()

    decimals =
      if m.expoente > 0 do
        Enum.join([decimal_separator, List.last(parts)])
      else
        ""
      end

    currency_symbol =
      if display_currency_symbol do
        m.simbolo
      else
        ""
      end

    currency_code =
      if display_currency_code do
        m.codigo
      else
        ""
      end

    [currency_symbol, " ", thousands, decimals, " ", currency_code]
    |> Enum.join()
    |> String.trim()
  end

  defp get_config(opts) do
    conf_thousand_separator =
      Application.get_env(:ex_dinheiro, :thousand_separator, ".")

    conf_decimal_separator =
      Application.get_env(:ex_dinheiro, :decimal_separator, ",")

    conf_display_currency_symbol =
      Application.get_env(:ex_dinheiro, :display_currency_symbol, true)

    conf_display_currency_code =
      Application.get_env(:ex_dinheiro, :display_currency_code, false)

    thousand_separator =
      Keyword.get(opts, :thousand_separator, conf_thousand_separator)

    decimal_separator =
      Keyword.get(opts, :decimal_separator, conf_decimal_separator)

    display_currency_symbol =
      Keyword.get(opts, :display_currency_symbol, conf_display_currency_symbol)

    display_currency_code =
      Keyword.get(opts, :display_currency_code, conf_display_currency_code)

    {thousand_separator, decimal_separator, display_currency_symbol,
     display_currency_code}
  end

  defp format_thousands([head | tail], separator, opts \\ []) do
    position = Keyword.get(opts, :position, 1)

    num =
      if rem(position, 3) == 0 and head != "-" and tail != [] do
        Enum.join([head, separator])
      else
        head
      end

    if tail != [] do
      [num, format_thousands(tail, separator, position: position + 1)]
      |> Enum.join()
    else
      num
    end
  end
end
