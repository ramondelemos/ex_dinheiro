defmodule Moeda do
  @moduledoc """

  [![Build Status](https://travis-ci.org/ramondelemos/ex_dinheiro.svg?branch=master)](https://travis-ci.org/ramondelemos/ex_dinheiro?branch=master)
  [![Coverage Status](https://coveralls.io/repos/github/ramondelemos/ex_dinheiro/badge.svg?branch=master)](https://coveralls.io/github/ramondelemos/ex_dinheiro?branch=master)

  """

  alias Moeda.Moedas

  defstruct [:name, :symbol, :alpha_code, :num_code, :exponent]

  @typedoc """
      Type that represents Moeda struct with:
      :name as String.t that represents the name of the currency.
      :symbol as String.t that represents symbol of the currency.
      :alpha_code as String.t that represents the alphabetic ISO 4217 code.
      :num_code as integer that represents the numeric ISO 4217 code. Where possible the 3 digit numeric code is the same as the numeric country code.
      :exponent as integer that represents the exponent of the currency.
  """
  @type t :: %__MODULE__{
          name: String.t(),
          symbol: String.t(),
          alpha_code: String.t(),
          num_code: integer,
          exponent: integer
        }

  @spec find!(String.t() | atom) :: t
  @doc """
  Return a map from an atom or string that represents an ISO 4217 code.

  ## Examples

      iex> Moeda.find!(:BRL)
      %Moeda{name: "Brazilian Real", symbol: 'R$', alpha_code: "BRL", num_code: 986, exponent: 2}
      iex> Moeda.find!(986)
      %Moeda{name: "Brazilian Real", symbol: 'R$', alpha_code: "BRL", num_code: 986, exponent: 2}
      iex> Moeda.find!(:NONE)
      ** (ArgumentError) 'NONE' does not represent an ISO 4217 code
  """
  def find!(num_code) when is_integer(num_code) do
    num_code
    |> do_find
  end

  def find!(alpha_code) when is_atom(alpha_code) do
    alpha_code
    |> Atom.to_string()
    |> String.upcase()
    |> String.to_atom()
    |> do_find
  end

  def find!(alpha_code) when is_binary(alpha_code) do
    alpha_code
    |> String.upcase()
    |> String.to_atom()
    |> do_find
  end

  defp do_find(alpha_code) when is_atom(alpha_code) do
    unofficial_currencies = get_unofficial_currencies()

    currencies = Moedas.get_currencies()

    alpha_code
    |> do_find(unofficial_currencies, currencies)
  end

  defp do_find(num_code) when is_integer(num_code) do
    unofficial_currencies =
      get_unofficial_currencies()
      |> Enum.map(fn {_key, currency} -> {currency.num_code, currency} end)
      |> Map.new()

    currencies = Moedas.get_currencies_by_num_code()

    num_code
    |> do_find(unofficial_currencies, currencies)
  end

  defp do_find(code, unofficial_currencies, currencies) do
    currency = unofficial_currencies[code]

    result =
      if currency do
        currency
      else
        currencies
        |> Map.get(code)
      end

    unless result,
      do:
        raise(
          ArgumentError,
          message: "'#{code}' does not represent an ISO 4217 code"
        )

    raise_if_is_not_moeda(result, code)

    result
  end

  defp get_unofficial_currencies do
    :ex_dinheiro
    |> Application.get_env(:unofficial_currencies, %{})
    |> Enum.map(fn {key, currency} ->
      {key, currency}
    end)
    |> Enum.filter(fn {key, currency} ->
      with true <- is_atom(key), {true, _} <- is_moeda(currency) do
        true
      else
        _ -> false
      end
    end)
    |> Map.new()
  end

  defp is_moeda(
         %__MODULE__{
           name: n,
           symbol: s,
           alpha_code: i,
           num_code: c,
           exponent: e
         } = m
       )
       when is_binary(n) and is_list(s) and is_binary(i) and is_integer(c) and
              is_integer(e),
       do: {true, m}

  defp is_moeda(value), do: {false, value}

  defp raise_if_is_not_moeda(value, alpha_code) do
    case is_moeda(value) do
      {true, _} ->
        true

      {false, _} ->
        raise(
          ArgumentError,
          message: ":#{alpha_code} must to be associated to a Moeda struct"
        )
    end
  end

  @spec find(String.t() | atom) :: {:ok, t} | {:error, String.t()}
  @doc """
  Return a map from an atom or string that represents an ISO 4217 code.

  ## Examples

      iex> Moeda.find(:BRL)
      {:ok, %Moeda{name: "Brazilian Real", symbol: 'R$', alpha_code: "BRL", num_code: 986, exponent: 2}}
      iex> Moeda.find("BRL")
      {:ok, %Moeda{name: "Brazilian Real", symbol: 'R$', alpha_code: "BRL", num_code: 986, exponent: 2}}
      iex> Moeda.find(986)
      {:ok, %Moeda{name: "Brazilian Real", symbol: 'R$', alpha_code: "BRL", num_code: 986, exponent: 2}}
      iex> Moeda.find("NONE")
      {:error, "'NONE' does not represent an ISO 4217 code"}

  Its function ignore case sensitive.

  ## Examples

      iex> Moeda.find(:brl)
      {:ok, %Moeda{name: "Brazilian Real", symbol: 'R$', alpha_code: "BRL", num_code: 986, exponent: 2}}
      iex> Moeda.find("brl")
      {:ok, %Moeda{name: "Brazilian Real", symbol: 'R$', alpha_code: "BRL", num_code: 986, exponent: 2}}

  Is possible to work with no official ISO currency code adding it in the system Mix config.

  ## Examples

      iex> Moeda.find(:XBT)
      {:error, "'XBT' does not represent an ISO 4217 code"}
      iex> currencies = %{ XBT: %Moeda{name: "Bitcoin", symbol: '฿', alpha_code: "XBT", num_code: 0, exponent: 8} }
      iex> Application.put_env(:ex_dinheiro, :unofficial_currencies, currencies)
      iex> Moeda.find("xbt")
      {:ok, %Moeda{name: "Bitcoin", symbol: '฿', alpha_code: "XBT", num_code: 0, exponent: 8}}

  Is possible to override some official ISO currency code adding it in the system Mix config.

  ## Examples

      iex> Moeda.find(:BRL)
      {:ok, %Moeda{name: "Brazilian Real", symbol: 'R$', alpha_code: "BRL", num_code: 986, exponent: 2}}
      iex> currencies = %{ BRL: %Moeda{name: "Moeda do Brasil", symbol: 'BR$', alpha_code: "BRL", num_code: 986, exponent: 4}, USD: %Moeda{name: "Moeda do EUA", symbol: 'US$', alpha_code: "USD", num_code: 986, exponent: 3} }
      iex> Application.put_env(:ex_dinheiro, :unofficial_currencies, currencies)
      iex> Moeda.find(:BRL)
      {:ok, %Moeda{name: "Moeda do Brasil", symbol: 'BR$', alpha_code: "BRL", num_code: 986, exponent: 4}}
      iex> Moeda.find(:USD)
      {:ok, %Moeda{name: "Moeda do EUA", symbol: 'US$', alpha_code: "USD", num_code: 986, exponent: 3}}
      iex> Application.delete_env(:ex_dinheiro, :unofficial_currencies)
      iex> Moeda.find(:BRL)
      {:ok, %Moeda{name: "Brazilian Real", symbol: 'R$', alpha_code: "BRL", num_code: 986, exponent: 2}}

  Be careful setting new currencies to Mix config.

  ## Examples

      iex> Moeda.find(:XBT)
      {:error, "'XBT' does not represent an ISO 4217 code"}
      iex> currencies = %{ XBT: %{name: "Bitcoin", symbol: '฿', alpha_code: "XBT", num_code: 0, exponent: 8} }
      iex> Application.put_env(:ex_dinheiro, :unofficial_currencies, currencies)
      iex> Moeda.find(:XBT)
      {:error, "'XBT' does not represent an ISO 4217 code"}
      iex> currencies = %{ XBT: %Moeda{name: "Bitcoin", symbol: '฿', alpha_code: "XBT", num_code: 0, exponent: 8} }
      iex> Application.put_env(:ex_dinheiro, :unofficial_currencies, currencies)
      iex> Moeda.find("xbt")
      {:ok, %Moeda{name: "Bitcoin", symbol: '฿', alpha_code: "XBT", num_code: 0, exponent: 8}}

  """
  def find(alpha_code)
      when is_atom(alpha_code) or is_binary(alpha_code) or
             is_integer(alpha_code) do
    {:ok, find!(alpha_code)}
  rescue
    e -> {:error, e.message}
  end

  @spec get_atom!(String.t() | atom) :: atom
  @doc """
  Return an atom from a value that represents an ISO 4217 code.

  ## Examples

      iex> Moeda.get_atom!(:BRL)
      :BRL
      iex> Moeda.get_atom!("BRL")
      :BRL
      iex> Moeda.get_atom!(:NONE)
      ** (ArgumentError) 'NONE' does not represent an ISO 4217 code

  Its function ignore case sensitive.

  ## Examples

      iex> Moeda.get_atom!(:brl)
      :BRL
      iex> Moeda.get_atom!("brl")
      :BRL

  """
  def get_atom!(alpha_code) do
    currency = find!(alpha_code)
    currency.alpha_code |> String.upcase() |> String.to_atom()
  end

  @spec get_atom(String.t() | atom) :: {:ok, atom}
  @doc """
  Return an atom from a value that represents an ISO 4217 code.

  ## Examples

      iex> Moeda.get_atom(:BRL)
      {:ok, :BRL}
      iex> Moeda.get_atom(:NONE)
      {:error, "'NONE' does not represent an ISO 4217 code"}

  """
  def get_atom(alpha_code) do
    {:ok, get_atom!(alpha_code)}
  rescue
    e -> {:error, e.message}
  end

  @spec get_factor!(String.t() | atom) :: float
  @doc """
  Return a multiplication factor from an ISO 4217 code.

  ## Examples

      iex> Moeda.get_factor!(:BRL)
      100.0
      iex> Moeda.get_factor!("BRL")
      100.0
      iex> Moeda.get_factor!(:NONE)
      ** (ArgumentError) 'NONE' does not represent an ISO 4217 code

  Its function ignore case sensitive.

  ## Examples

      iex> Moeda.get_factor!(:brl)
      100.0
      iex> Moeda.get_factor!("brl")
      100.0

  """
  def get_factor!(alpha_code) do
    currency = find!(alpha_code)
    :math.pow(10, currency.exponent)
  end

  @spec get_factor(String.t() | atom) :: {:ok, float} | {:error, String.t()}
  @doc """
  Return a multiplication factor from an ISO 4217 code.

  ## Examples

      iex> Moeda.get_factor(:BRL)
      {:ok, 100.0}
      iex> Moeda.get_factor(:NONE)
      {:error, "'NONE' does not represent an ISO 4217 code"}

  """
  def get_factor(alpha_code) do
    {:ok, get_factor!(alpha_code)}
  rescue
    e -> {:error, e.message}
  end

  @spec to_string(String.t() | atom, float, Keywords.t()) ::
          {:ok, String.t()} | {:error, String.t()}
  @doc """
  Return a formated string from a ISO 4217 code and a float value.

  ## Examples

      iex> Moeda.to_string(:BRL, 100.0)
      {:ok, "R$ 100,00"}
      iex> Moeda.to_string(:NONE, 1000.5)
      {:error, "'NONE' does not represent an ISO 4217 code"}
  """
  def to_string(currency, valor, opts \\ []) do
    {:ok, to_string!(currency, valor, opts)}
  rescue
    e -> {:error, e.message}
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
      iex> Moeda.to_string!(:NONE, 1000.5)
      ** (ArgumentError) 'NONE' does not represent an ISO 4217 code

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
  def to_string!(currency, valor, opts \\ []) do
    m = find!(currency)

    unless is_float(valor),
      do: raise(ArgumentError, message: "Value '#{valor}' must be float")

    {thousand_separator, decimal_separator, display_currency_symbol,
     display_currency_code} = get_config(opts)

    parts =
      valor
      |> :erlang.float_to_binary(decimals: m.exponent)
      |> String.split(".")

    thousands =
      parts
      |> List.first()
      |> String.reverse()
      |> String.codepoints()
      |> format_thousands(thousand_separator)
      |> String.reverse()

    decimals =
      if m.exponent > 0 do
        Enum.join([decimal_separator, List.last(parts)])
      else
        ""
      end

    currency_symbol =
      if display_currency_symbol do
        m.symbol
      else
        ""
      end

    currency_code =
      if display_currency_code do
        m.alpha_code
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
