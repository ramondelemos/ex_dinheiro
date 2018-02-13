defmodule Dinheiro do
  @moduledoc """
  Documentation for Dinheiro.
  """
  defstruct quantia: nil, moeda: nil

  @typedoc """
      Type that represents Dinheiro struct with:
      :quantia as integer
      :moeda as atom that represents an ISO 4217 code
  """
  @type t :: %Dinheiro{ quantia: integer, moeda: atom }

  @spec new(integer | float) :: t
  @doc """
  Create a new `Dinheiro` struct using a default value of Moeda.
  The default currency can be set in the system Mix config.

  ## Example:
        iex> Application.put_env(:ex_dinheiro, :default_moeda, :BRL)
        iex> Dinheiro.new(12345)
        %Dinheiro{ quantia: 1234500, moeda: :BRL }
        iex> Dinheiro.new(123.45)
        %Dinheiro{ quantia: 12345, moeda: :BRL }

  """
  def new(quantia) when is_integer(quantia) or is_float(quantia) do
    moeda = Application.get_env(:ex_dinheiro, :default_moeda)
    if moeda do
      new(quantia, moeda)
    else
      raise ArgumentError, "to use Dinheiro.new/1 you must set a default value in your application config :ex_dinheiro, default_moeda. #{moeda}."
    end
  end

  @spec new(integer | float, atom | String.t) :: t
  @doc """
  Create a new `Dinheiro` struct.
  
  ## Example:
      iex> Dinheiro.new(12345, :BRL)
      %Dinheiro{ quantia: 1234500, moeda: :BRL }
      iex> Dinheiro.new(12345, "BRL")
      %Dinheiro{ quantia: 1234500, moeda: :BRL }
      iex> Dinheiro.new(123.45, :BRL)
      %Dinheiro{ quantia: 12345, moeda: :BRL }
      iex> Dinheiro.new(123.45, "BRL")
      %Dinheiro{ quantia: 12345, moeda: :BRL }

  """
  def new(quantia, moeda) when is_integer(quantia) or is_float(quantia) do
    v_moeda = Moeda.find(moeda);
    if v_moeda do
      newp(round(quantia * :math.pow(10, v_moeda.expoente)), Moeda.get_atom(v_moeda.codigo))
    else
      raise ArgumentError, "to use Dinheiro.new/2 you must set a valid value to moeda."
    end
  end

  defp newp(quantia, moeda) when is_integer(quantia) and is_atom(moeda) do
    %Dinheiro{ quantia: quantia, moeda: moeda }
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
      result when result >  0 -> 1
      result when result <  0 -> -1
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
      %Dinheiro{ quantia: 200, moeda: :BRL }
      iex> Dinheiro.sum(Dinheiro.new(1, :BRL), 2)
      %Dinheiro{ quantia: 300, moeda: :BRL }
      iex> Dinheiro.sum(Dinheiro.new(1, :BRL), 2.5)
      %Dinheiro{ quantia: 350, moeda: :BRL }
      iex> Dinheiro.sum(Dinheiro.new(2, :BRL), -1)
      %Dinheiro{ quantia: 100, moeda: :BRL }

  """
  def sum(%Dinheiro{moeda: m} = a, %Dinheiro{moeda: m} = b) do
    %Dinheiro{ quantia: a.quantia + b.quantia, moeda: m }
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
      %Dinheiro{ quantia: 100, moeda: :BRL }
      iex> Dinheiro.subtract(Dinheiro.new(4, :BRL), 2)
      %Dinheiro{ quantia: 200, moeda: :BRL }
      iex> Dinheiro.subtract(Dinheiro.new(5, :BRL), 2.5)
      %Dinheiro{ quantia: 250, moeda: :BRL }
      iex> Dinheiro.subtract(Dinheiro.new(4, :BRL), -2)
      %Dinheiro{ quantia: 600, moeda: :BRL }

  """
  def subtract(a, b) do
  end

  defp raise_moeda_must_be_the_same(a, b) do
    raise ArgumentError, message: "Moeda of #{a.moeda} must be the same as #{b.moeda}"
  end
end
