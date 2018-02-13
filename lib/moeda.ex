defmodule Moeda do
  @moduledoc """
  Documentation for Moeda.
  """

  @moedas %{
    BRL: %{nome: "Brazilian Real", simbolo: "R$", codigo: "BRL", codigo_iso: 986, expoente: 2},
    USD: %{nome: "US Dollar", simbolo: "$", codigo: "USD", codigo_iso: 840, expoente: 2}
  }

  @spec find(String.t() | atom) :: map | nil
  @doc """
  Return a map from an atom or string that represents an ISO 4217 code.

  ## Examples

      iex> Moeda.find(:BRL)
      %{ nome: "Brazilian Real", simbolo: "R$", codigo: "BRL", codigo_iso: 986, expoente: 2 }
      iex> Moeda.find("BRL")
      %{ nome: "Brazilian Real", simbolo: "R$", codigo: "BRL", codigo_iso: 986, expoente: 2 }
      iex> Moeda.find("")
      nil

  Its function ignore case sensitive.

  ## Examples

      iex> Moeda.find(:brl)
      %{ nome: "Brazilian Real", simbolo: "R$", codigo: "BRL", codigo_iso: 986, expoente: 2 }
      iex> Moeda.find("brl")
      %{ nome: "Brazilian Real", simbolo: "R$", codigo: "BRL", codigo_iso: 986, expoente: 2 }

  """
  def find(codigo) when is_atom(codigo) do
    codigo |> Atom.to_string() |> String.upcase() |> String.to_atom() |> findp
  end

  def find(codigo) when is_binary(codigo) do
    codigo |> String.upcase() |> String.to_atom() |> findp
  end

  defp findp(codigo) do
    @moedas[codigo]
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
    moeda = find(codigo)

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
    moeda = find(codigo)

    if moeda do
      :math.pow(10, moeda.expoente)
    else
      nil
    end
  end
end
