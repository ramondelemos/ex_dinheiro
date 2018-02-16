defmodule Dinheiro do
  @moduledoc """
  Documentation for Dinheiro.
  """
  defstruct [:quantia, :moeda]

  @typedoc """
      Type that represents Dinheiro struct with:
      :quantia as integer
      :moeda as atom that represents an ISO 4217 code
  """
  @type t :: %Dinheiro{quantia: integer, moeda: atom}

  @spec new(integer | float) :: t
  @doc """
  Create a new `Dinheiro` struct using a default value of Moeda.
  The default currency can be set in the system Mix config.

  ## Example:
        iex> Application.put_env(:ex_dinheiro, :default_moeda, :BRL)
        iex> Dinheiro.new(12345)
        %Dinheiro{quantia: 1234500, moeda: :BRL}
        iex> Dinheiro.new(123.45)
        %Dinheiro{quantia: 12345, moeda: :BRL}

  """
  def new(quantia) when is_integer(quantia) or is_float(quantia) do
    moeda = Application.get_env(:ex_dinheiro, :default_moeda)

    if moeda do
      new(quantia, moeda)
    else
      raise ArgumentError,
            "to use Dinheiro.new/1 you must set a default value in your application config :ex_dinheiro, default_moeda. #{
              moeda
            }."
    end
  end

  @spec new(integer | float, atom | String.t()) :: t
  @doc """
  Create a new `Dinheiro` struct.

  ## Example:
      iex> Dinheiro.new(12345, :BRL)
      %Dinheiro{quantia: 1234500, moeda: :BRL}
      iex> Dinheiro.new(12345, "BRL")
      %Dinheiro{quantia: 1234500, moeda: :BRL}
      iex> Dinheiro.new(123.45, :BRL)
      %Dinheiro{quantia: 12345, moeda: :BRL}
      iex> Dinheiro.new(123.45, "BRL")
      %Dinheiro{quantia: 12345, moeda: :BRL}

  """
  def new(quantia, moeda) when is_integer(quantia) or is_float(quantia) do
    v_moeda = Moeda.find(moeda)

    if v_moeda do
      factor =
        v_moeda.codigo
        |> Moeda.get_factor()

      atom =
        v_moeda.codigo
        |> Moeda.get_atom()

      valor = quantia * factor

      valor
      |> round
      |> newp(atom)
    else
      raise ArgumentError, "to use Dinheiro.new/2 you must set a valid value to moeda."
    end
  end

  defp newp(quantia, moeda) when is_integer(quantia) and is_atom(moeda) do
    %Dinheiro{quantia: quantia, moeda: moeda}
  end

  @spec compare(t, t) :: integer
  @doc """
  Compares two `Dinheiro` structs with each other.
  They must each be of the same moeda and then their value are compared
  ## Example:
      iex> Dinheiro.compare(Dinheiro.new(12345, :BRL), Dinheiro.new(12345, :BRL))
      0
      iex> Dinheiro.compare(Dinheiro.new(12345, :BRL), Dinheiro.new(12346, :BRL))
      -1
      iex> Dinheiro.compare(Dinheiro.new(12346, :BRL), Dinheiro.new(12345, :BRL))
      1
  """
  def compare(%Dinheiro{moeda: m} = a, %Dinheiro{moeda: m} = b) do
    case a.quantia - b.quantia do
      result when result > 0 -> 1
      result when result < 0 -> -1
      result when result == 0 -> 0
    end
  end

  def compare(a, b) do
    raise_moeda_must_be_the_same(a, b)
  end

  @spec sum(t, t | integer | float) :: t
  @doc """
  Return a new `Dinheiro` structs with sum of two values.
  The first parameter must be a struct of `Dinheiro`.

  ## Example:
      iex> Dinheiro.sum(Dinheiro.new(1, :BRL), Dinheiro.new(1, :BRL))
      %Dinheiro{quantia: 200, moeda: :BRL}
      iex> Dinheiro.sum(Dinheiro.new(1, :BRL), 2)
      %Dinheiro{quantia: 300, moeda: :BRL}
      iex> Dinheiro.sum(Dinheiro.new(1, :BRL), 2.5)
      %Dinheiro{quantia: 350, moeda: :BRL}
      iex> Dinheiro.sum(Dinheiro.new(2, :BRL), -1)
      %Dinheiro{quantia: 100, moeda: :BRL}

  """
  def sum(%Dinheiro{moeda: m} = a, %Dinheiro{moeda: m} = b) do
    %Dinheiro{quantia: a.quantia + b.quantia, moeda: m}
  end

  def sum(%Dinheiro{moeda: m} = a, b) when is_integer(b) or is_float(b) do
    sum(a, Dinheiro.new(b, m))
  end

  def sum(a, b) do
    raise_moeda_must_be_the_same(a, b)
  end

  @spec subtract(t, t | integer | float) :: t
  @doc """
  Return a new `Dinheiro` structs with subtract of two values.
  The first parameter must be a struct of `Dinheiro`.

  ## Example:
      iex> Dinheiro.subtract(Dinheiro.new(2, :BRL), Dinheiro.new(1, :BRL))
      %Dinheiro{quantia: 100, moeda: :BRL}
      iex> Dinheiro.subtract(Dinheiro.new(4, :BRL), 2)
      %Dinheiro{quantia: 200, moeda: :BRL}
      iex> Dinheiro.subtract(Dinheiro.new(5, :BRL), 2.5)
      %Dinheiro{quantia: 250, moeda: :BRL}
      iex> Dinheiro.subtract(Dinheiro.new(4, :BRL), -2)
      %Dinheiro{quantia: 600, moeda: :BRL}

  """
  def subtract(%Dinheiro{moeda: m} = a, %Dinheiro{moeda: m} = b) do
    %Dinheiro{quantia: a.quantia - b.quantia, moeda: m}
  end

  def subtract(%Dinheiro{moeda: m} = a, b) when is_integer(b) or is_float(b) do
    subtract(a, Dinheiro.new(b, m))
  end

  def subtract(a, b) do
    raise_moeda_must_be_the_same(a, b)
  end

  @spec multiply(t, integer | float) :: t
  @doc """
  Return a new `Dinheiro` structs with value multiplied by other value.
  The first parameter must be a struct of `Dinheiro`.

  ## Example:
      iex> Dinheiro.multiply(Dinheiro.new(2, :BRL), 2)
      %Dinheiro{quantia: 400, moeda: :BRL}
      iex> Dinheiro.multiply(Dinheiro.new(5, :BRL), 2.5)
      %Dinheiro{quantia: 1250, moeda: :BRL}
      iex> Dinheiro.multiply(Dinheiro.new(4, :BRL), -2)
      %Dinheiro{quantia: -800, moeda: :BRL}

  """
  def multiply(%Dinheiro{moeda: m} = a, b) when is_integer(b) or is_float(b) do
    float_value = to_float(a)
    new(float_value * b, m)
  end

  @spec divide(t, integer | [integer]) :: [t]
  @doc """
  Divide a `Dinheiro` struct by a positive integer value

  ## Example:
      iex> Dinheiro.divide(Dinheiro.new(100, :BRL), 2)
      [%Dinheiro{quantia: 5000, moeda: :BRL}, %Dinheiro{quantia: 5000, moeda: :BRL}]
      iex> Dinheiro.divide(Dinheiro.new(101, :BRL), 2)
      [%Dinheiro{quantia: 5050, moeda: :BRL}, %Dinheiro{quantia: 5050, moeda: :BRL}]

  Divide a `Dinheiro` struct by an list of values that represents a division ratio.

  ## Example:
      iex> Dinheiro.divide(Dinheiro.new(0.05, :BRL), [3, 7])
      [%Dinheiro{quantia: 2, moeda: :BRL}, %Dinheiro{quantia: 3, moeda: :BRL}]

  """
  def divide(%Dinheiro{moeda: m} = a, b) when is_integer(b) do
    assert_if_ratios_are_valid([b])
    division = div(a.quantia, b)
    remainder = rem(a.quantia, b)
    to_alocate(division, remainder, m, b)
  end

  def divide(%Dinheiro{moeda: m} = a, b) when is_list(b) do
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
          newp(head + 1, moeda)
        else
          newp(head, moeda)
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
        |> newp(moeda)

      [dinheiro | to_alocate(division, remainder - 1, moeda, position - 1)]
    else
      []
    end
  end

  defp sum_values([]), do: 0
  defp sum_values([head | tail]), do: head + sum_values(tail)

  @spec to_float(t) :: float
  @doc """
  Return a float value from a `Dinheiro` structs.

  ## Example:
      iex> Dinheiro.to_float(%Dinheiro{quantia: 200, moeda: :BRL})
      2.0
      iex> Dinheiro.to_float(Dinheiro.new(50.5, :BRL))
      50.5
      iex> Dinheiro.to_float(Dinheiro.new(-4, :BRL))
      -4.0

  """
  def to_float(%Dinheiro{moeda: m} = from) do
    moeda = Moeda.find(m)
    unless moeda, do: raise(ArgumentError, message: "'#{m}' does not represent an ISO 4217 code.")
    factor = Moeda.get_factor(m)
    Float.round(from.quantia / factor, moeda.expoente)
  end

  @spec to_string(t, Keywords.t()) :: String.t()
  @doc """
  Return a formated string from a `Dinheiro` struct.

  ## Example:
      iex> Dinheiro.to_string(%Dinheiro{quantia: 200, moeda: :BRL})
      "R$ 2,00"
      iex> Dinheiro.to_string(Dinheiro.new(50.5, :BRL))
      "R$ 50,50"
      iex> Dinheiro.to_string(Dinheiro.new(-4, :BRL))
      "R$ -4,00"

  Using options-style parameters you can change the behavior of the function.

    - `thousand_separator` - default `"."`, sets the thousand separator.
    - `decimal_separator` - default `","`, sets the decimal separator.

  ## Exemples

      iex> Dinheiro.to_string(Dinheiro.new(1000.5, :USD), thousand_separator: ",", decimal_separator: ".")
      "$ 1,000.50"

  """
  def to_string(%Dinheiro{moeda: m} = from, opts \\ []) do
    value = to_float(from)
    Moeda.to_string(m, value, opts)
  end

  defp raise_moeda_must_be_the_same(a, b) do
    raise ArgumentError, message: "Moeda of #{a.moeda} must be the same as #{b.moeda}"
  end

  defp assert_if_value_is_positive(value) when is_integer(value) do
    if value < 0, do: raise(ArgumentError, message: "Value #{value} must be positive.")
  end

  defp assert_if_greater_than_zero(value) when is_integer(value) do
    if value == 0, do: raise(ArgumentError, message: "Value must be greater than zero.")
  end

  defp assert_if_ratios_are_valid([head | tail]) do
    unless is_integer(head), do: raise(ArgumentError, message: "Value '#{head}' must be integer.")
    assert_if_value_is_positive(head)
    assert_if_greater_than_zero(head)
    if tail != [], do: assert_if_ratios_are_valid(tail)
  end
end
