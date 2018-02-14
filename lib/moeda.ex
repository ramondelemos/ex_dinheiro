defmodule Moeda do
  @moduledoc """
  Documentation for Moeda.
  """

  @moedas %{
    BRL: %{ nome: "Brazilian Real", simbolo: "R$", codigo: "BRL", codigo_iso: 986, expoente: 2 },
    USD: %{ nome: "US Dollar", simbolo: "$", codigo: "USD", codigo_iso: 840, expoente: 2 }
  }

  @spec find(String.t | atom) :: map | nil
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
    codigo |> Atom.to_string |> String.upcase |>  String.to_atom |> findp
  end

  def find(codigo) when is_binary(codigo) do
    codigo |> String.upcase |>  String.to_atom |> findp
  end

  defp findp(codigo) do
    @moedas[codigo]
  end

  @spec get_atom(String.t | atom) :: atom | nil
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
      moeda.codigo |> String.upcase |> String.to_atom
    else
      nil
    end
  end

  @spec get_factor(String.t | atom) :: float | nil
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

  @spec to_string(String.t | atom, float, Keywords.t) :: String.t | nil
  @doc """
  Return a formated string from a ISO 4217 code and a float value.

  ## Examples

      iex> Moeda.to_string(:BRL, 100.0)
      "R$ 100,00"
      iex> Moeda.to_string("BRL", 1000.5)
      "R$ 1.000,50"
      iex> Moeda.to_string(:BRL, -1.0)
      "R$ -1,00"

  Its function ignore case sensitive.

  ## Examples

      iex> Moeda.to_string(:bRl, 100.0)
      "R$ 100,00"
      iex> Moeda.to_string("BrL", 1000.5)
      "R$ 1.000,50"

  Using options-style parameters you can change the behavior of the function.

    - `thousand_separator` - default `"."`, sets the thousand separator.
    - `decimal_separator` - default `","`, sets the decimal separator.

  ## Exemples

      iex> Moeda.to_string(:USD, 1000.5, thousand_separator: ",", decimal_separator: ".")
      "$ 1,000.50"

  """
  def to_string(moeda, valor, opts \\ []) do
    thousand_separator = Keyword.get(opts, :thousand_separator, ".")
    decimal_separator = Keyword.get(opts, :decimal_separator, ",")
    
    m = Moeda.find(moeda)

    unless m do
      raise ArgumentError, message: "'#{moeda}' does not represent an ISO 4217 code."
    end

    unless is_float(valor) do
      raise ArgumentError, message: "Value '#{valor}' must be float."
    end

    parts = String.split(:erlang.float_to_binary(valor, decimals: m.expoente), ".")
    thousands = List.first(parts)
    thousands = String.reverse(thousands)
    thousands = format_thousands(String.codepoints(thousands), thousand_separator)
    thousands = String.reverse(thousands)

    decimals = if m.expoente > 0 do      
      Enum.join([decimal_separator, List.last(parts)])
    else
      ""
    end

    String.trim(Enum.join([m.simbolo, " ", thousands, decimals]))
  end

  defp format_thousands([head | tail], separator, opts \\ []) do
    position = Keyword.get(opts, :position, 1)

    num = if rem(position, 3) == 0 and head != "-" and tail != [] do
      Enum.join([head, separator])
    else
      head
    end

    if tail != [] do
      Enum.join([num, format_thousands(tail, separator, position: position + 1)])
    else
      num
    end
  end

end
