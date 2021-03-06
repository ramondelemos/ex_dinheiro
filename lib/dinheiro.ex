defmodule Dinheiro do
  @moduledoc """

  [![Build Status](https://travis-ci.org/ramondelemos/ex_dinheiro.svg?branch=master)](https://travis-ci.org/ramondelemos/ex_dinheiro?branch=master)
  [![Coverage Status](https://coveralls.io/repos/github/ramondelemos/ex_dinheiro/badge.svg?branch=master)](https://coveralls.io/github/ramondelemos/ex_dinheiro?branch=master)

  """

  defstruct [:amount, :currency]

  @typedoc """
      Type that represents Dinheiro struct with:
      :amount as integer that represents an amount.
      :currency as atom that represents an ISO 4217 code.
  """
  @type t :: %__MODULE__{amount: integer, currency: atom}

  @spec new(integer | float) :: {:ok, t} | {:error, String.t()}
  @doc """
  Create a new `Dinheiro` struct using a default currency.
  The default currency can be set in the system Mix config.

  ## Example:
        iex> Application.put_env(:ex_dinheiro, :default_currency, :BRL)
        iex> Dinheiro.new(12345)
        {:ok, %Dinheiro{amount: 1234500, currency: :BRL}}
        iex> Dinheiro.new("1")
        {:error, "value '1' must be integer or float"}
        iex> Application.delete_env(:ex_dinheiro, :default_currency)
        iex> Dinheiro.new(12345)
        {:error, "you must set a default value in your application config :ex_dinheiro, default_currency"}

  """
  def new(amount) do
    {:ok, new!(amount)}
  rescue
    e -> {:error, e.message}
  end

  @spec new!(integer | float) :: t
  @doc """
  Create a new `Dinheiro` struct using a default currency.
  The default currency can be set in the system Mix config.

  ## Example:
        iex> Application.put_env(:ex_dinheiro, :default_currency, :BRL)
        iex> Dinheiro.new!(12345)
        %Dinheiro{amount: 1234500, currency: :BRL}
        iex> Dinheiro.new!(123.45)
        %Dinheiro{amount: 12345, currency: :BRL}
        iex> Dinheiro.new!("1")
        ** (ArgumentError) value '1' must be integer or float

  """
  def new!(amount) when is_integer(amount) or is_float(amount) do
    currency = Application.get_env(:ex_dinheiro, :default_currency)

    if currency do
      new!(amount, currency)
    else
      raise ArgumentError,
            "you must set a default value in your application config :ex_dinheiro, default_currency"
    end
  end

  def new!(amount) do
    raise_if_not_integer_or_float(amount)
  end

  @spec new(integer | float, atom | String.t()) ::
          {:ok, t} | {:error, String.t()}
  @doc """
  Create a new `Dinheiro` struct.

  ## Example:
      iex> Dinheiro.new(12345, :BRL)
      {:ok, %Dinheiro{amount: 1234500, currency: :BRL}}
      iex> Dinheiro.new("1", :BRL)
      {:error, "value '1' must be integer or float"}
      iex> Dinheiro.new(12345, :XBT)
      {:error, "'XBT' does not represent an ISO 4217 code"}
      iex> currencies = %{ XBT: %Moeda{name: "Bitcoin", symbol: '฿', alpha_code: "XBT", num_code: 0, exponent: 8} }
      iex> Application.put_env(:ex_dinheiro, :unofficial_currencies, currencies)
      iex> Dinheiro.new(123.45, :XBT)
      {:ok, %Dinheiro{amount: 12345000000, currency: :XBT}}

  """
  def new(amount, currency) do
    {:ok, new!(amount, currency)}
  rescue
    e -> {:error, e.message}
  end

  @spec new!(integer | float, atom | String.t()) :: t
  @doc """
  Create a new `Dinheiro` struct.

  ## Example:
      iex> Dinheiro.new!(12345, :BRL)
      %Dinheiro{amount: 1234500, currency: :BRL}
      iex> Dinheiro.new!(12345, "BRL")
      %Dinheiro{amount: 1234500, currency: :BRL}
      iex> Dinheiro.new!(123.45, :BRL)
      %Dinheiro{amount: 12345, currency: :BRL}
      iex> Dinheiro.new!(123.45, "BRL")
      %Dinheiro{amount: 12345, currency: :BRL}
      iex> Dinheiro.new!(12345, :NONE)
      ** (ArgumentError) 'NONE' does not represent an ISO 4217 code

  Is possible to work with no official ISO currency code adding it in the system Mix config.

  ## Examples

      iex> Moeda.find(:XBT)
      {:error, "'XBT' does not represent an ISO 4217 code"}
      iex> currencies = %{ XBT: %Moeda{name: "Bitcoin", symbol: '฿', alpha_code: "XBT", num_code: 0, exponent: 8} }
      iex> Application.put_env(:ex_dinheiro, :unofficial_currencies, currencies)
      iex> Dinheiro.new!(123.45, :XBT)
      %Dinheiro{amount: 12345000000, currency: :XBT}

  """
  def new!(amount, currency) when is_integer(amount) or is_float(amount) do
    v_currency = Moeda.find!(currency)

    factor =
      v_currency.alpha_code
      |> Moeda.get_factor!()

    atom =
      v_currency.alpha_code
      |> Moeda.get_atom!()

    valor = amount * factor

    valor
    |> round
    |> do_new(atom)
  end

  def new!(amount, _c) do
    raise_if_not_integer_or_float(amount)
  end

  defp do_new(amount, currency) when is_integer(amount) and is_atom(currency) do
    %Dinheiro{amount: amount, currency: currency}
  end

  @spec compare(t, t) :: {:ok, integer} | {:error, String.t()}
  @doc """
  Compares two `Dinheiro` structs with each other.
  They must each be of the same currency and then their value are compared.

  ## Example:
      iex> Dinheiro.compare(Dinheiro.new!(12345, :BRL), Dinheiro.new!(12345, :BRL))
      {:ok, 0}
      iex> Dinheiro.compare(Dinheiro.new!(12345, :BRL), Dinheiro.new!(12346, :BRL))
      {:ok, -1}
      iex> Dinheiro.compare(Dinheiro.new!(12346, :BRL), Dinheiro.new!(12345, :BRL))
      {:ok, 1}
      iex> Dinheiro.compare(Dinheiro.new!(12346, :USD), Dinheiro.new!(12346, :BRL))
      {:error, "currency :BRL different of :USD"}
  """
  def compare(a, b) do
    {:ok, compare!(a, b)}
  rescue
    e -> {:error, e.message}
  end

  @spec compare!(t, t) :: integer
  @doc """
  Compares two `Dinheiro` structs with each other.
  They must each be of the same currency and then their value are compared.

  ## Example:
      iex> Dinheiro.compare!(Dinheiro.new!(12345, :BRL), Dinheiro.new!(12345, :BRL))
      0
      iex> Dinheiro.compare!(Dinheiro.new!(12345, :BRL), Dinheiro.new!(12346, :BRL))
      -1
      iex> Dinheiro.compare!(Dinheiro.new!(12346, :BRL), Dinheiro.new!(12345, :BRL))
      1
      iex> Dinheiro.compare!(Dinheiro.new!(12346, :USD), Dinheiro.new!(12346, :BRL))
      ** (ArgumentError) currency :BRL different of :USD
  """
  def compare!(%__MODULE__{currency: m} = a, %__MODULE__{currency: m} = b) do
    case a.amount - b.amount do
      result when result > 0 -> 1
      result when result < 0 -> -1
      result when result == 0 -> 0
    end
  end

  def compare!(a, b) do
    raise_currency_must_be_the_same(a, b)
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
  def equals?(%__MODULE__{currency: currency, amount: amount}, %__MODULE__{
        currency: currency,
        amount: amount
      }),
      do: true

  def equals?(_, _), do: false

  @spec sum(t, t | integer | float) :: {:ok, t} | {:error, String.t()}
  @doc """
  Return a new `Dinheiro` structs with sum of two values.
  The first parameter must be a struct of `Dinheiro`.

  ## Example:
      iex> Dinheiro.sum(Dinheiro.new!(2, :BRL), Dinheiro.new!(1, :BRL))
      {:ok, %Dinheiro{amount: 300, currency: :BRL}}
      iex> Dinheiro.sum(%Dinheiro{amount: 100, currency: :NONE}, 2)
      {:error, "'NONE' does not represent an ISO 4217 code"}
      iex> Dinheiro.sum(2, 2)
      {:error, "value must be a Dinheiro struct"}
      iex> Dinheiro.sum(Dinheiro.new!(2, :BRL), "1")
      {:error, "value '1' must be integer or float"}
      iex> Dinheiro.sum(%Dinheiro{amount: 100, currency: :NONE}, %Dinheiro{amount: 100, currency: :NONE})
      {:error, "'NONE' does not represent an ISO 4217 code"}

  """
  def sum(a, b) do
    {:ok, sum!(a, b)}
  rescue
    e -> {:error, e.message}
  end

  @spec sum!(t, t | integer | float) :: t
  @doc """
  Return a new `Dinheiro` structs with sum of two values.
  The first parameter must be a struct of `Dinheiro`.

  ## Example:
      iex> Dinheiro.sum!(Dinheiro.new!(1, :BRL), Dinheiro.new!(1, :BRL))
      %Dinheiro{amount: 200, currency: :BRL}
      iex> Dinheiro.sum!(Dinheiro.new!(1, :BRL), 2)
      %Dinheiro{amount: 300, currency: :BRL}
      iex> Dinheiro.sum!(Dinheiro.new!(1, :BRL), 2.5)
      %Dinheiro{amount: 350, currency: :BRL}
      iex> Dinheiro.sum!(Dinheiro.new!(2, :BRL), -1)
      %Dinheiro{amount: 100, currency: :BRL}
      iex> Dinheiro.sum!(Dinheiro.new!(2, :BRL), "1")
      ** (ArgumentError) value '1' must be integer or float

  """
  def sum!(%__MODULE__{currency: m} = a, %__MODULE__{currency: m} = b) do
    raise_if_is_not_a_currency_valid(m)
    %Dinheiro{amount: a.amount + b.amount, currency: m}
  end

  def sum!(%__MODULE__{currency: m} = a, b) when is_integer(b) or is_float(b) do
    sum!(a, Dinheiro.new!(b, m))
  end

  def sum!(a, %__MODULE__{currency: _m} = b) do
    raise_if_is_not_dinheiro(a)
    raise_currency_must_be_the_same(a, b)
  end

  def sum!(a, b) do
    raise_if_is_not_dinheiro(a)
    raise_if_not_integer_or_float(b)
  end

  @spec sum([t()]) :: {:ok, t()} | {:error, String.t()}
  @doc """
  Return a new `Dinheiro` structs with sum of a list of `Dinheiro` structs.

  ## Example:
      iex> a = Dinheiro.new!(1, :BRL)
      iex> b = Dinheiro.new!(1, :BRL)
      iex> c = Dinheiro.new!(1, :BRL)
      iex> d = Dinheiro.new!(1, :BRL)
      iex> values = [a, b, c, d]
      iex> Dinheiro.sum(values)
      {:ok, %Dinheiro{amount: 400, currency: :BRL}}

  The first item currency will be the result currency.

  ## Example:
      iex> a = Dinheiro.new!(1, :BRL)
      iex> b = Dinheiro.new!(1, :USD)
      iex> c = Dinheiro.new!(1, :USD)
      iex> d = Dinheiro.new!(1, :USD)
      iex> e = Dinheiro.new!(1, :USD)
      iex> Dinheiro.sum([a, b, c, d, e])
      {:error, "currency :USD different of :BRL"}
      iex> Dinheiro.sum([b, a, c, d, e])
      {:error, "currency :BRL different of :USD"}

  """
  def sum(values) do
    {:ok, sum!(values)}
  rescue
    e -> {:error, e.message}
  end

  @spec sum!([t]) :: t
  @doc """
  Return a new `Dinheiro` structs with sum of a list of `Dinheiro` structs.

  ## Example:
      iex> a = Dinheiro.new!(1, :BRL)
      iex> b = Dinheiro.new!(1, :BRL)
      iex> c = Dinheiro.new!(1, :BRL)
      iex> d = Dinheiro.new!(1, :BRL)
      iex> values = [a, b, c, d]
      iex> Dinheiro.sum!(values)
      %Dinheiro{amount: 400, currency: :BRL}

  The first item currency will be the result currency.

  ## Example:
      iex> a = Dinheiro.new!(1, :BRL)
      iex> b = Dinheiro.new!(1, :USD)
      iex> c = Dinheiro.new!(1, :USD)
      iex> d = Dinheiro.new!(1, :USD)
      iex> e = Dinheiro.new!(1, :USD)
      iex> values = [a, b, c, d, e]
      iex> Dinheiro.sum!(values)
      ** (ArgumentError) currency :USD different of :BRL

  """
  def sum!(values) when is_list(values) do
    unless Enum.count(values) > 0,
      do:
        raise(
          ArgumentError,
          message: "list can not be empty"
        )

    [head | tail] = values

    raise_if_is_not_dinheiro(head)
    raise_if_is_not_a_currency_valid(head.currency)

    [head | tail]
    |> Enum.map(fn i -> get_integer_value_async(head.currency, i) end)
    |> Enum.map(&Task.await/1)
    |> sum_async_returns!()
    |> do_new(head.currency)
  end

  def sum!(_) do
    raise(
      ArgumentError,
      message: "must be a list of Dinheiro struct"
    )
  end

  defp get_integer_value(currency, money) do
    raise_if_is_not_dinheiro(money)

    unless currency == money.currency,
      do: raise_currency_must_be_the_same(currency, money.currency)

    {:ok, money.amount}
  rescue
    e -> {:error, e}
  end

  defp get_integer_value_async(currency, money) do
    Task.async(fn -> get_integer_value(currency, money) end)
  end

  defp sum_async_returns!([]), do: 0

  defp sum_async_returns!([head | tail]) do
    case head do
      {:ok, value} -> value + sum_async_returns!(tail)
      {:error, reason} -> raise reason
    end
  end

  @spec subtract(t, t | integer | float) :: {:ok, t} | {:error, String.t()}
  @doc """
  Return a new `Dinheiro` structs with subtract of two values.
  The first parameter must be a struct of `Dinheiro`.

  ## Example:
      iex> Dinheiro.subtract(Dinheiro.new!(2, :BRL), Dinheiro.new!(1, :BRL))
      {:ok, %Dinheiro{amount: 100, currency: :BRL}}
      iex> Dinheiro.subtract(%Dinheiro{amount: 100, currency: :NONE}, 2)
      {:error, "'NONE' does not represent an ISO 4217 code"}
      iex> Dinheiro.subtract(2, 2)
      {:error, "value must be a Dinheiro struct"}
      iex> Dinheiro.subtract(Dinheiro.new!(2, :BRL), "1")
      {:error, "value '1' must be integer or float"}
      iex> Dinheiro.subtract(%Dinheiro{amount: 100, currency: :NONE}, %Dinheiro{amount: 100, currency: :NONE})
      {:error, "'NONE' does not represent an ISO 4217 code"}

  """
  def subtract(a, b) do
    {:ok, subtract!(a, b)}
  rescue
    e -> {:error, e.message}
  end

  @spec subtract!(t, t | integer | float) :: t
  @doc """
  Return a new `Dinheiro` structs with subtract of two values.
  The first parameter must be a struct of `Dinheiro`.

  ## Example:
      iex> Dinheiro.subtract!(Dinheiro.new!(2, :BRL), Dinheiro.new!(1, :BRL))
      %Dinheiro{amount: 100, currency: :BRL}
      iex> Dinheiro.subtract!(Dinheiro.new!(4, :BRL), 2)
      %Dinheiro{amount: 200, currency: :BRL}
      iex> Dinheiro.subtract!(Dinheiro.new!(5, :BRL), 2.5)
      %Dinheiro{amount: 250, currency: :BRL}
      iex> Dinheiro.subtract!(Dinheiro.new!(4, :BRL), -2)
      %Dinheiro{amount: 600, currency: :BRL}
      iex> Dinheiro.subtract!(%Dinheiro{amount: 100, currency: :NONE}, %Dinheiro{amount: 100, currency: :NONE})
      ** (ArgumentError) 'NONE' does not represent an ISO 4217 code

  """
  def subtract!(%__MODULE__{currency: m} = a, %__MODULE__{currency: m} = b) do
    raise_if_is_not_a_currency_valid(m)
    %Dinheiro{amount: a.amount - b.amount, currency: m}
  end

  def subtract!(%__MODULE__{currency: m} = a, b)
      when is_integer(b) or is_float(b) do
    subtract!(a, Dinheiro.new!(b, m))
  end

  def subtract!(a, %__MODULE__{currency: _m} = b) do
    raise_if_is_not_dinheiro(a)
    raise_currency_must_be_the_same(a, b)
  end

  def subtract!(a, b) do
    raise_if_is_not_dinheiro(a)
    raise_if_not_integer_or_float(b)
  end

  @spec multiply(t, integer | float) :: {:ok, t} | {:error, String.t()}
  @doc """
  Return a new `Dinheiro` structs with value multiplied by other value.
  The first parameter must be a struct of `Dinheiro`.

  ## Example:
      iex> Dinheiro.multiply(Dinheiro.new!(2, :BRL), 2)
      {:ok, %Dinheiro{amount: 400, currency: :BRL}}
      iex> Dinheiro.multiply(2, 2)
      {:error, "value must be a Dinheiro struct"}

  """
  def multiply(a, b) do
    {:ok, multiply!(a, b)}
  rescue
    e -> {:error, e.message}
  end

  @spec multiply!(t, integer | float) :: t
  @doc """
  Return a new `Dinheiro` structs with value multiplied by other value.
  The first parameter must be a struct of `Dinheiro`.

  ## Example:
      iex> Dinheiro.multiply!(Dinheiro.new!(2, :BRL), 2)
      %Dinheiro{amount: 400, currency: :BRL}
      iex> Dinheiro.multiply!(Dinheiro.new!(5, :BRL), 2.5)
      %Dinheiro{amount: 1250, currency: :BRL}
      iex> Dinheiro.multiply!(Dinheiro.new!(4, :BRL), -2)
      %Dinheiro{amount: -800, currency: :BRL}
      iex> Dinheiro.multiply!(2, 2)
      ** (ArgumentError) value must be a Dinheiro struct

  """
  def multiply!(a, b) when is_integer(b) or is_float(b) do
    raise_if_is_not_dinheiro(a)
    float_value = to_float!(a)
    new!(float_value * b, a.currency)
  end

  @spec divide(t, integer | [integer]) :: {:ok, [t]} | {:error, String.t()}
  @doc """
  Divide a `Dinheiro` struct by a positive integer value

  ## Example:
      iex> Dinheiro.divide(Dinheiro.new!(100, :BRL), 2)
      {:ok, [%Dinheiro{amount: 5000, currency: :BRL}, %Dinheiro{amount: 5000, currency: :BRL}]}
      iex> Dinheiro.divide(%Dinheiro{amount: 5050, currency: :NONE}, 2)
      {:error, "'NONE' does not represent an ISO 4217 code"}

  Divide a `Dinheiro` struct by an list of values that represents a division ratio.

  ## Example:
      iex> Dinheiro.divide(Dinheiro.new!(0.05, :BRL), [3, 7])
      {:ok, [%Dinheiro{amount: 2, currency: :BRL}, %Dinheiro{amount: 3, currency: :BRL}]}

  """
  def divide(%__MODULE__{currency: _m} = a, b)
      when is_integer(b) or is_list(b) do
    {:ok, divide!(a, b)}
  rescue
    e -> {:error, e.message}
  end

  @spec divide!(t, integer | [integer]) :: [t]
  @doc """
  Divide a `Dinheiro` struct by a positive integer value

  ## Example:
      iex> Dinheiro.divide!(Dinheiro.new!(100, :BRL), 2)
      [%Dinheiro{amount: 5000, currency: :BRL}, %Dinheiro{amount: 5000, currency: :BRL}]
      iex> Dinheiro.divide!(Dinheiro.new!(101, :BRL), 2)
      [%Dinheiro{amount: 5050, currency: :BRL}, %Dinheiro{amount: 5050, currency: :BRL}]
      iex> Dinheiro.divide!(%Dinheiro{amount: 5050, currency: :NONE}, 2)
      ** (ArgumentError) 'NONE' does not represent an ISO 4217 code

  Divide a `Dinheiro` struct by an list of values that represents a division ratio.

  ## Example:
      iex> Dinheiro.divide!(Dinheiro.new!(0.05, :BRL), [3, 7])
      [%Dinheiro{amount: 2, currency: :BRL}, %Dinheiro{amount: 3, currency: :BRL}]

  """
  def divide!(%__MODULE__{currency: m} = a, b) when is_integer(b) do
    raise_if_is_not_a_currency_valid(m)
    raise_if_not_ratios_are_valid([b])
    division = div(a.amount, b)
    remainder = rem(a.amount, b)
    to_alocate(division, remainder, m, b)
  end

  def divide!(%__MODULE__{currency: m} = a, b) when is_list(b) do
    raise_if_is_not_a_currency_valid(m)
    raise_if_not_ratios_are_valid(b)
    ratio = sum_values(b)
    division = calculate_ratio(b, ratio, a.amount)
    remainder = a.amount - sum_values(division)
    to_alocate(division, remainder, m)
  end

  defp calculate_ratio(ratios, ratio, value) do
    ratios
    |> Enum.map(&div(value * &1, ratio))
  end

  defp to_alocate([head | tail], remainder, currency) do
    if head do
      dinheiro =
        if remainder > 0 do
          do_new(head + 1, currency)
        else
          do_new(head, currency)
        end

      rem =
        if remainder > 0 do
          remainder - 1
        else
          remainder
        end

      if tail != [] do
        [dinheiro | to_alocate(tail, rem, currency)]
      else
        [dinheiro]
      end
    else
      []
    end
  end

  defp to_alocate(division, remainder, currency, position) do
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
        |> do_new(currency)

      [dinheiro | to_alocate(division, remainder - 1, currency, position - 1)]
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
      iex> Dinheiro.to_float(%Dinheiro{amount: 200, currency: :BRL})
      {:ok, 2.0}
      iex> Dinheiro.to_float(%Dinheiro{amount: 200, currency: :NONE})
      {:error, "'NONE' does not represent an ISO 4217 code"}

  """
  def to_float(%__MODULE__{currency: _m} = from) do
    {:ok, to_float!(from)}
  rescue
    e -> {:error, e.message}
  end

  @spec to_float!(t) :: float
  @doc """
  Return a float value from a `Dinheiro` structs.

  ## Example:
      iex> Dinheiro.to_float!(%Dinheiro{amount: 200, currency: :BRL})
      2.0
      iex> Dinheiro.to_float!(Dinheiro.new!(50.5, :BRL))
      50.5
      iex> Dinheiro.to_float!(Dinheiro.new!(-4, :BRL))
      -4.0
      iex> Dinheiro.to_float!(%Dinheiro{amount: 200, currency: :NONE})
      ** (ArgumentError) 'NONE' does not represent an ISO 4217 code

  """
  def to_float!(%__MODULE__{currency: m} = from) do
    currency = Moeda.find!(m)
    factor = Moeda.get_factor!(m)
    Float.round(from.amount / factor, currency.exponent)
  end

  @spec to_string(t, Keywords.t()) :: {:ok, String.t()} | {:error, String.t()}
  @doc """
  Return a formated string from a `Dinheiro` struct.

  ## Example:
      iex> Dinheiro.to_string(%Dinheiro{amount: 200, currency: :BRL})
      {:ok, "R$ 2,00"}
      iex> Dinheiro.to_string(%Dinheiro{amount: 200, currency: :NONE})
      {:error, "'NONE' does not represent an ISO 4217 code"}
  """
  def to_string(%__MODULE__{currency: _m} = from, opts \\ []) do
    {:ok, to_string!(from, opts)}
  rescue
    e -> {:error, e.message}
  end

  @spec to_string!(t, Keywords.t()) :: String.t()
  @doc """
  Return a formated string from a `Dinheiro` struct.

  ## Example:
      iex> Dinheiro.to_string!(%Dinheiro{amount: 200, currency: :BRL})
      "R$ 2,00"
      iex> Dinheiro.to_string!(Dinheiro.new!(50.5, :BRL))
      "R$ 50,50"
      iex> Dinheiro.to_string!(Dinheiro.new!(-4, :BRL))
      "R$ -4,00"
      iex> Dinheiro.to_string!(%Dinheiro{amount: 200, currency: :NONE})
      ** (ArgumentError) 'NONE' does not represent an ISO 4217 code

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
      iex> Dinheiro.to_string!(%Dinheiro{amount: 200, currency: :XBT})
      ** (ArgumentError) 'XBT' does not represent an ISO 4217 code
      iex> real = %Moeda{name: "Moeda do Brasil", symbol: 'BR$', alpha_code: "BRL", num_code: 986, exponent: 4}
      %Moeda{name: "Moeda do Brasil", symbol: 'BR$', alpha_code: "BRL", num_code: 986, exponent: 4}
      iex> dollar = %Moeda{name: "Moeda do EUA", symbol: 'US$', alpha_code: "USD", num_code: 840, exponent: 3}
      %Moeda{name: "Moeda do EUA", symbol: 'US$', alpha_code: "USD", num_code: 840, exponent: 3}
      iex> bitcoin = %Moeda{name: "Bitcoin", symbol: '฿', alpha_code: "XBT", num_code: 0, exponent: 8}
      %Moeda{name: "Bitcoin", symbol: '฿', alpha_code: "XBT", num_code: 0, exponent: 8}
      iex> currencies = %{ BRL: real, USD: dollar, XBT: bitcoin }
      iex> Application.put_env(:ex_dinheiro, :unofficial_currencies, currencies)
      iex> Dinheiro.to_string!(Dinheiro.new!(12_345_678.9, :BRL))
      "BR$ 12.345.678,9000"
      iex> Dinheiro.to_string!(Dinheiro.new!(12_345_678.9, :usd))
      "US$ 12.345.678,900"
      iex> Dinheiro.to_string!(Dinheiro.new!(12_345_678.9, "XBT"))
      "฿ 12.345.678,90000000"

  """
  def to_string!(%__MODULE__{currency: m} = from, opts \\ []) do
    value = to_float!(from)
    Moeda.to_string!(m, value, opts)
  end

  @spec is_dinheiro?(any()) :: boolean()
  @doc """
  Return if value is a `Dinheiro` struct.

  ## Example:
      iex> Dinheiro.is_dinheiro?(%Dinheiro{amount: 200, currency: :BRL})
      true
      iex> Dinheiro.is_dinheiro?(%{amount: 200, currency: :BRL})
      false
      iex> Dinheiro.is_dinheiro?(200)
      false
  """
  def is_dinheiro?(%__MODULE__{amount: a, currency: c})
      when is_integer(a) and is_atom(c),
      do: true

  def is_dinheiro?(_value), do: false

  defp raise_currency_must_be_the_same(a, b) when is_atom(a) and is_atom(b) do
    raise ArgumentError, message: "currency :#{b} different of :#{a}"
  end

  defp raise_currency_must_be_the_same(a, b) do
    raise_currency_must_be_the_same(a.currency, b.currency)
  end

  defp raise_if_value_is_not_positive(value) when is_integer(value) do
    if value < 0,
      do: raise(ArgumentError, message: "value #{value} must be positive")
  end

  defp raise_if_not_greater_than_zero(value) when is_integer(value) do
    if value == 0,
      do: raise(ArgumentError, message: "value must be greater than zero")
  end

  defp raise_if_not_integer_or_float(value) do
    unless is_integer(value) or is_float(value),
      do:
        raise(
          ArgumentError,
          message: "value '#{value}' must be integer or float"
        )
  end

  defp raise_if_not_integer(value) do
    unless is_integer(value),
      do: raise(ArgumentError, message: "value '#{value}' must be integer")
  end

  defp raise_if_not_ratios_are_valid([head | tail]) do
    raise_if_not_integer(head)
    raise_if_value_is_not_positive(head)
    raise_if_not_greater_than_zero(head)
    if tail != [], do: raise_if_not_ratios_are_valid(tail)
  end

  defp raise_if_is_not_a_currency_valid(m), do: Moeda.find!(m)

  defp raise_if_is_not_dinheiro(value) do
    case is_dinheiro?(value) do
      true ->
        true

      false ->
        raise(
          ArgumentError,
          message: "value must be a Dinheiro struct"
        )
    end
  end
end
