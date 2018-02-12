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

  @spec new(integer) :: t
  @doc """
  Create a new `Dinheiro` struct using a default value of Moeda.
  The default currency can be set in the system Mix config.
  ## Example Config:
      config :ex_dinheiro, default_moeda: :BRL
  ## Example:
      Dinheiro.new(12345)
      %Dinheiro{ quantia: 12345, moeda: :BRL }
  """
  def new(quantia) when is_integer(quantia) do
    moeda = Application.get_env(:ex_dinheiro, :default_moeda)
    if moeda do
      new(quantia, moeda)
    else
      raise ArgumentError, "to use Dinheiro.new/1 you must set a default value in your application config :ex_dinheiro, default_moeda."
    end
  end

  @spec new(integer, atom | String.t) :: t
  @doc """
  Create a new `Dinheiro` struct.
  
  ## Example:
      Dinheiro.new(12345, :BRL)
      %Dinheiro{ quantia: 12345, moeda: :BRL }
      Dinheiro.new(12345, "BRL")
      %Dinheiro{ quantia: 12345, moeda: :BRL }

  """
  def new(quantia, moeda) when is_integer(quantia) do
    v_moeda = Moeda.get_atom(moeda);
    if v_moeda do
      newp(quantia, v_moeda)
    else
      raise ArgumentError, "to use Dinheiro.new/2 you must set a valid value to moeda."
    end
  end

  defp newp(quantia, moeda) when is_integer(quantia) and is_atom(moeda) do
    %Dinheiro{ quantia: quantia, moeda: moeda }
  end
end
