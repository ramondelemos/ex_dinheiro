defmodule Dinheiro do
  @moduledoc """

  [![Build Status](https://travis-ci.org/ramondelemos/ex_dinheiro.svg?branch=master)](https://travis-ci.org/ramondelemos/ex_dinheiro?branch=master)
  [![Coverage Status](https://coveralls.io/repos/github/ramondelemos/ex_dinheiro/badge.svg?branch=master)](https://coveralls.io/github/ramondelemos/ex_dinheiro?branch=master)

  """

  defstruct [:quantia, :moeda]

  @typedoc """
      Type that represents Dinheiro struct with:
      :quantia as integer that represents an amount.
      :moeda as atom that represents an ISO 4217 code.
  """
  @type t :: %Dinheiro{quantia: integer, moeda: atom}

  @spec new(integer | float) :: {:ok, t} | {:error, String.t()}
  @doc """
  Create a new `Dinheiro` struct using a default currency.
  The default currency can be set in the system Mix config.

  ## Example:
        iex> Application.put_env(:ex_dinheiro, :default_currency, :BRL)
        iex> Dinheiro.new(12345)
        {:ok, %Dinheiro{quantia: 1234500, moeda: :BRL}}
        iex> Application.delete_env(:ex_dinheiro, :default_currency)
        iex> Dinheiro.new(12345)
        {:error, "you must set a default value in your application config :ex_dinheiro, default_currency."}

  """
  def new(quantia) do
    try do
      {:ok, new!(quantia)}
    rescue
      e -> {:error, e.message}
    end
  end

  @spec new!(integer | float) :: t
  @doc """
  Create a new `Dinheiro` struct using a default currency.
  The default currency can be set in the system Mix config.

  ## Example:
        iex> Application.put_env(:ex_dinheiro, :default_currency, :BRL)
        iex> Dinheiro.new!(12345)
        %Dinheiro{quantia: 1234500, moeda: :BRL}
        iex> Dinheiro.new!(123.45)
        %Dinheiro{quantia: 12345, moeda: :BRL}

  """
  def new!(quantia) when is_integer(quantia) or is_float(quantia) do
    moeda = Application.get_env(:ex_dinheiro, :default_currency)

    if moeda do
      new!(quantia, moeda)
    else
      raise ArgumentError,
            "you must set a default value in your application config :ex_dinheiro, default_currency."
    end
  end

  @spec new!(integer | float, atom | String.t()) :: t
  @doc """
  Create a new `Dinheiro` struct.

  ## Example:
      iex> Dinheiro.new!(12345, :BRL)
      %Dinheiro{quantia: 1234500, moeda: :BRL}
      iex> Dinheiro.new!(12345, "BRL")
      %Dinheiro{quantia: 1234500, moeda: :BRL}
      iex> Dinheiro.new!(123.45, :BRL)
      %Dinheiro{quantia: 12345, moeda: :BRL}
      iex> Dinheiro.new!(123.45, "BRL")
      %Dinheiro{quantia: 12345, moeda: :BRL}

  Is possible to work with no official ISO currency code adding it in the system Mix config.

  ## Examples

      iex> Moeda.find(:XBT)
      {:error, "'XBT' does not represent an ISO 4217 code."}
      iex> moedas = %{ XBT: %Moeda{nome: "Bitcoin", simbolo: '฿', codigo: "XBT", codigo_iso: 0, expoente: 8} }
      iex> Application.put_env(:ex_dinheiro, :unofficial_currencies, moedas)
      iex> Dinheiro.new!(123.45, :XBT)
      %Dinheiro{quantia: 12345000000, moeda: :XBT}

  """
  def new!(quantia, moeda) when is_integer(quantia) or is_float(quantia) do
    v_moeda = Moeda.find!(moeda)

    if v_moeda do
      factor =
        v_moeda.codigo
        |> Moeda.get_factor()

      atom =
        v_moeda.codigo
        |> Moeda.get_atom!()

      valor = quantia * factor

      valor
      |> round
      |> do_new(atom)
    else
      raise ArgumentError,
            "to use Dinheiro.new!/2 you must set a valid value to moeda."
    end
  end

  defp do_new(quantia, moeda) when is_integer(quantia) and is_atom(moeda) do
    %Dinheiro{quantia: quantia, moeda: moeda}
  end

  @spec compare!(t, t) :: integer
  @doc """
  Compares two `Dinheiro` structs with each other.
  They must each be of the same moeda and then their value are compared.

  ## Example:
      iex> Dinheiro.compare!(Dinheiro.new!(12345, :BRL), Dinheiro.new!(12345, :BRL))
      0
      iex> Dinheiro.compare!(Dinheiro.new!(12345, :BRL), Dinheiro.new!(12346, :BRL))
      -1
      iex> Dinheiro.compare!(Dinheiro.new!(12346, :BRL), Dinheiro.new!(12345, :BRL))
      1
  """
  def compare!(%Dinheiro{moeda: m} = a, %Dinheiro{moeda: m} = b) do
    case a.quantia - b.quantia do
      result when result > 0 -> 1
      result when result < 0 -> -1
      result when result == 0 -> 0
    end
  end

  def compare!(a, b) do
    raise_moeda_must_be_the_same(a, b)
  end

  @spec equals?(t, t) :: boolean
  @doc """
  Retun `true` if two `Dinheiro` structs are equals.

  ## Example:
      iex> Dinheiro.equals?(Dinheiro.new!(12345, :BRL), Dinheiro.new!(12345, :BRL))
      true
      iex> Dinheiro.equals?(Dinheiro.new!(12345, :BRL), Dinheiro.new!(12346, :BRL))
      false
      iex> Dinheiro.equals?(Dinheiro.new!(12345, :BRL), Dinheiro.new!(12345, :USD))
      false
  """
  def equals?(%Dinheiro{moeda: moeda, quantia: quantia}, %Dinheiro{
        moeda: moeda,
        quantia: quantia
      }),
      do: true

  def equals?(_, _), do: false

  @spec sum!(t, t | integer | float) :: t
  @doc """
  Return a new `Dinheiro` structs with sum of two values.
  The first parameter must be a struct of `Dinheiro`.

  ## Example:
      iex> Dinheiro.sum!(Dinheiro.new!(1, :BRL), Dinheiro.new!(1, :BRL))
      %Dinheiro{quantia: 200, moeda: :BRL}
      iex> Dinheiro.sum!(Dinheiro.new!(1, :BRL), 2)
      %Dinheiro{quantia: 300, moeda: :BRL}
      iex> Dinheiro.sum!(Dinheiro.new!(1, :BRL), 2.5)
      %Dinheiro{quantia: 350, moeda: :BRL}
      iex> Dinheiro.sum!(Dinheiro.new!(2, :BRL), -1)
      %Dinheiro{quantia: 100, moeda: :BRL}

  """
  def sum!(%Dinheiro{moeda: m} = a, %Dinheiro{moeda: m} = b) do
    %Dinheiro{quantia: a.quantia + b.quantia, moeda: m}
  end

  def sum!(%Dinheiro{moeda: m} = a, b) when is_integer(b) or is_float(b) do
    sum!(a, Dinheiro.new!(b, m))
  end

  def sum!(a, b) do
    raise_moeda_must_be_the_same(a, b)
  end

  @spec subtract!(t, t | integer | float) :: t
  @doc """
  Return a new `Dinheiro` structs with subtract of two values.
  The first parameter must be a struct of `Dinheiro`.

  ## Example:
      iex> Dinheiro.subtract!(Dinheiro.new!(2, :BRL), Dinheiro.new!(1, :BRL))
      %Dinheiro{quantia: 100, moeda: :BRL}
      iex> Dinheiro.subtract!(Dinheiro.new!(4, :BRL), 2)
      %Dinheiro{quantia: 200, moeda: :BRL}
      iex> Dinheiro.subtract!(Dinheiro.new!(5, :BRL), 2.5)
      %Dinheiro{quantia: 250, moeda: :BRL}
      iex> Dinheiro.subtract!(Dinheiro.new!(4, :BRL), -2)
      %Dinheiro{quantia: 600, moeda: :BRL}

  """
  def subtract!(%Dinheiro{moeda: m} = a, %Dinheiro{moeda: m} = b) do
    %Dinheiro{quantia: a.quantia - b.quantia, moeda: m}
  end

  def subtract!(%Dinheiro{moeda: m} = a, b) when is_integer(b) or is_float(b) do
    subtract!(a, Dinheiro.new!(b, m))
  end

  def subtract!(a, b) do
    raise_moeda_must_be_the_same(a, b)
  end

  @spec multiply!(t, integer | float) :: t
  @doc """
  Return a new `Dinheiro` structs with value multiplied by other value.
  The first parameter must be a struct of `Dinheiro`.

  ## Example:
      iex> Dinheiro.multiply!(Dinheiro.new!(2, :BRL), 2)
      %Dinheiro{quantia: 400, moeda: :BRL}
      iex> Dinheiro.multiply!(Dinheiro.new!(5, :BRL), 2.5)
      %Dinheiro{quantia: 1250, moeda: :BRL}
      iex> Dinheiro.multiply!(Dinheiro.new!(4, :BRL), -2)
      %Dinheiro{quantia: -800, moeda: :BRL}

  """
  def multiply!(%Dinheiro{moeda: m} = a, b) when is_integer(b) or is_float(b) do
    float_value = to_float!(a)
    new!(float_value * b, m)
  end

  @spec divide(t, integer | [integer]) :: {:ok, [t]} | {:error, String.t()}
  @doc """
  Divide a `Dinheiro` struct by a positive integer value

  ## Example:
      iex> Dinheiro.divide(Dinheiro.new!(100, :BRL), 2)
      {:ok, [%Dinheiro{quantia: 5000, moeda: :BRL}, %Dinheiro{quantia: 5000, moeda: :BRL}]}
      iex> Dinheiro.divide(%Dinheiro{quantia: 5050, moeda: :NONE}, 2)
      {:error, "'NONE' does not represent an ISO 4217 code."}

  Divide a `Dinheiro` struct by an list of values that represents a division ratio.

  ## Example:
      iex> Dinheiro.divide(Dinheiro.new!(0.05, :BRL), [3, 7])
      {:ok, [%Dinheiro{quantia: 2, moeda: :BRL}, %Dinheiro{quantia: 3, moeda: :BRL}]}

  """
  def divide(%Dinheiro{moeda: _m} = a, b) when is_integer(b) or is_list(b) do
    try do
      {:ok, divide!(a, b)}
    rescue
      e -> {:error, e.message}
    end
  end

  @spec divide!(t, integer | [integer]) :: [t]
  @doc """
  Divide a `Dinheiro` struct by a positive integer value

  ## Example:
      iex> Dinheiro.divide!(Dinheiro.new!(100, :BRL), 2)
      [%Dinheiro{quantia: 5000, moeda: :BRL}, %Dinheiro{quantia: 5000, moeda: :BRL}]
      iex> Dinheiro.divide!(Dinheiro.new!(101, :BRL), 2)
      [%Dinheiro{quantia: 5050, moeda: :BRL}, %Dinheiro{quantia: 5050, moeda: :BRL}]

  Divide a `Dinheiro` struct by an list of values that represents a division ratio.

  ## Example:
      iex> Dinheiro.divide!(Dinheiro.new!(0.05, :BRL), [3, 7])
      [%Dinheiro{quantia: 2, moeda: :BRL}, %Dinheiro{quantia: 3, moeda: :BRL}]

  """
  def divide!(%Dinheiro{moeda: m} = a, b) when is_integer(b) do
    assert_if_moeda_is_valid(m)
    assert_if_ratios_are_valid([b])
    division = div(a.quantia, b)
    remainder = rem(a.quantia, b)
    to_alocate(division, remainder, m, b)
  end

  def divide!(%Dinheiro{moeda: m} = a, b) when is_list(b) do
    assert_if_moeda_is_valid(m)
    assert_if_ratios_are_valid(b)
    ratio = sum_values(b)
    division = calculate_ratio(b, ratio, a.quantia)
    remainder = a.quantia - sum_values(division)
    to_alocate(division, remainder, m)
  end

  defp calculate_ratio(ratios, ratio, value) do
    ratios
    |> Enum.map(&div(value * &1, ratio))
  end

  defp to_alocate([head | tail], remainder, moeda) do
    if head do
      dinheiro =
        if remainder > 0 do
          do_new(head + 1, moeda)
        else
          do_new(head, moeda)
        end

      rem =
        if remainder > 0 do
          remainder - 1
        else
          remainder
        end

      if tail != [] do
        [dinheiro | to_alocate(tail, rem, moeda)]
      else
        [dinheiro]
      end
    else
      []
    end
  end

  defp to_alocate(division, remainder, moeda, position) do
    some =
      if remainder > 0 do
        1
      else
        0
      end

    if position > 0 do
      value = division + some

      dinheiro =
        value
        |> do_new(moeda)

      [dinheiro | to_alocate(division, remainder - 1, moeda, position - 1)]
    else
      []
    end
  end

  defp sum_values([]), do: 0
  defp sum_values([head | tail]), do: head + sum_values(tail)

  @spec to_float(t) :: {:ok, float} | {:error, String.t()}
  @doc """
  Return a float value from a `Dinheiro` structs.

  ## Example:
      iex> Dinheiro.to_float(%Dinheiro{quantia: 200, moeda: :BRL})
      {:ok, 2.0}
      iex> Dinheiro.to_float(%Dinheiro{quantia: 200, moeda: :NONE})
      {:error, "'NONE' does not represent an ISO 4217 code."}

  """
  def to_float(%Dinheiro{moeda: _m} = from) do
    try do
      {:ok, to_float!(from)}
    rescue
      e -> {:error, e.message}
    end
  end

  @spec to_float!(t) :: float
  @doc """
  Return a float value from a `Dinheiro` structs.

  ## Example:
      iex> Dinheiro.to_float!(%Dinheiro{quantia: 200, moeda: :BRL})
      2.0
      iex> Dinheiro.to_float!(Dinheiro.new!(50.5, :BRL))
      50.5
      iex> Dinheiro.to_float!(Dinheiro.new!(-4, :BRL))
      -4.0

  """
  def to_float!(%Dinheiro{moeda: m} = from) do
    moeda = Moeda.find!(m)
    factor = Moeda.get_factor(m)
    Float.round(from.quantia / factor, moeda.expoente)
  end

  @spec to_string(t, Keywords.t()) :: {:ok, String.t()} | {:error, String.t()}
  @doc """
  Return a formated string from a `Dinheiro` struct.

  ## Example:
      iex> Dinheiro.to_string(%Dinheiro{quantia: 200, moeda: :BRL})
      {:ok, "R$ 2,00"}
      iex> Dinheiro.to_string(%Dinheiro{quantia: 200, moeda: :NONE})
      {:error, "'NONE' does not represent an ISO 4217 code."}
  """
  def to_string(%Dinheiro{moeda: _m} = from, opts \\ []) do
    try do
      {:ok, to_string!(from, opts)}
    rescue
      e -> {:error, e.message}
    end
  end

  @spec to_string!(t, Keywords.t()) :: String.t()
  @doc """
  Return a formated string from a `Dinheiro` struct.

  ## Example:
      iex> Dinheiro.to_string!(%Dinheiro{quantia: 200, moeda: :BRL})
      "R$ 2,00"
      iex> Dinheiro.to_string!(Dinheiro.new!(50.5, :BRL))
      "R$ 50,50"
      iex> Dinheiro.to_string!(Dinheiro.new!(-4, :BRL))
      "R$ -4,00"

  Using options-style parameters you can change the behavior of the function.

    - `thousand_separator` - default `"."`, sets the thousand separator.
    - `decimal_separator` - default `","`, sets the decimal separator.
    - `display_currency_symbol` - default `true`, put to `false` to hide de currency symbol.
    - `display_currency_code` - default `false`, put to `true` to display de currency ISO 4217 code.

  ## Exemples

      iex> Dinheiro.to_string!(Dinheiro.new!(1000.5, :USD), thousand_separator: ",", decimal_separator: ".")
      "$ 1,000.50"
      iex> Dinheiro.to_string!(Dinheiro.new!(1000.5, :USD), display_currency_symbol: false)
      "1.000,50"
      iex> Dinheiro.to_string!(Dinheiro.new!(1000.5, :USD), display_currency_code: true)
      "$ 1.000,50 USD"
      iex> Dinheiro.to_string!(Dinheiro.new!(1000.5, :USD), display_currency_code: true, display_currency_symbol: false)
      "1.000,50 USD"

  The default values also can be set in the system Mix config.

  ## Example:
      iex> Application.put_env(:ex_dinheiro, :thousand_separator, ",")
      iex> Application.put_env(:ex_dinheiro, :decimal_separator, ".")
      iex> Dinheiro.to_string!(Dinheiro.new!(1000.5, :USD))
      "$ 1,000.50"
      iex> Application.put_env(:ex_dinheiro, :display_currency_symbol, false)
      iex> Dinheiro.to_string!(Dinheiro.new!(5000.5, :USD))
      "5,000.50"
      iex> Application.put_env(:ex_dinheiro, :display_currency_code, true)
      iex> Dinheiro.to_string!(Dinheiro.new!(10000.0, :USD))
      "10,000.00 USD"

  The options-style parameters override values in the system Mix config.

  ## Example:
      iex> Application.put_env(:ex_dinheiro, :thousand_separator, ",")
      iex> Application.put_env(:ex_dinheiro, :decimal_separator, ".")
      iex> Dinheiro.to_string!(Dinheiro.new!(1000.5, :USD))
      "$ 1,000.50"
      iex> Dinheiro.to_string!(Dinheiro.new!(1000.5, :BRL), thousand_separator: ".", decimal_separator: ",")
      "R$ 1.000,50"

  Is possible to override some official ISO currency code adding it in the system Mix config.

  ## Examples

      iex> Dinheiro.to_string!(Dinheiro.new!(12_345_678.9, :BRL))
      "R$ 12.345.678,90"
      iex> Dinheiro.to_string!(Dinheiro.new!(12_345_678.9, :USD))
      "$ 12.345.678,90"
      iex> Dinheiro.to_string!(%Dinheiro{quantia: 200, moeda: :XBT})
      ** (ArgumentError) 'XBT' does not represent an ISO 4217 code.
      iex> real = %Moeda{nome: "Moeda do Brasil", simbolo: 'BR$', codigo: "BRL", codigo_iso: 986, expoente: 4}
      %Moeda{nome: "Moeda do Brasil", simbolo: 'BR$', codigo: "BRL", codigo_iso: 986, expoente: 4}
      iex> dollar = %Moeda{nome: "Moeda do EUA", simbolo: 'US$', codigo: "USD", codigo_iso: 840, expoente: 3}
      %Moeda{nome: "Moeda do EUA", simbolo: 'US$', codigo: "USD", codigo_iso: 840, expoente: 3}
      iex> bitcoin = %Moeda{nome: "Bitcoin", simbolo: '฿', codigo: "XBT", codigo_iso: 0, expoente: 8}
      %Moeda{nome: "Bitcoin", simbolo: '฿', codigo: "XBT", codigo_iso: 0, expoente: 8}
      iex> moedas = %{ BRL: real, USD: dollar, XBT: bitcoin }
      iex> Application.put_env(:ex_dinheiro, :unofficial_currencies, moedas)
      iex> Dinheiro.to_string!(Dinheiro.new!(12_345_678.9, :BRL))
      "BR$ 12.345.678,9000"
      iex> Dinheiro.to_string!(Dinheiro.new!(12_345_678.9, :usd))
      "US$ 12.345.678,900"
      iex> Dinheiro.to_string!(Dinheiro.new!(12_345_678.9, "XBT"))
      "฿ 12.345.678,90000000"

  """
  def to_string!(%Dinheiro{moeda: m} = from, opts \\ []) do
    value = to_float!(from)
    Moeda.to_string!(m, value, opts)
  end

  defp raise_moeda_must_be_the_same(a, b) do
    raise ArgumentError,
      message: "Moeda of #{a.moeda} must be the same as #{b.moeda}"
  end

  defp assert_if_value_is_positive(value) when is_integer(value) do
    if value < 0,
      do: raise(ArgumentError, message: "Value #{value} must be positive.")
  end

  defp assert_if_greater_than_zero(value) when is_integer(value) do
    if value == 0,
      do: raise(ArgumentError, message: "Value must be greater than zero.")
  end

  defp assert_if_ratios_are_valid([head | tail]) do
    unless is_integer(head),
      do: raise(ArgumentError, message: "Value '#{head}' must be integer.")

    assert_if_value_is_positive(head)
    assert_if_greater_than_zero(head)
    if tail != [], do: assert_if_ratios_are_valid(tail)
  end

  defp assert_if_moeda_is_valid(m), do: Moeda.find!(m)
end
