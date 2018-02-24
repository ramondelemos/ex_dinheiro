defmodule DinheiroTest do
  use ExUnit.Case
  doctest Dinheiro

  setup do
    Application.delete_env(:ex_dinheiro, :default_currency)
    Application.delete_env(:ex_dinheiro, :thousand_separator)
    Application.delete_env(:ex_dinheiro, :decimal_separator)
    Application.delete_env(:ex_dinheiro, :display_currency_symbol)
    Application.delete_env(:ex_dinheiro, :display_currency_code)
    Application.delete_env(:ex_dinheiro, :unofficial_currencies)
  end

  test "new/1" do
    assert Dinheiro.new(12345) ==
             {:error,
              "you must set a default value in your application config :ex_dinheiro, default_currency."}

    Application.put_env(:ex_dinheiro, :default_currency, :BRL)

    assert Dinheiro.new(12345) ==
             {:ok, %Dinheiro{quantia: 1_234_500, moeda: :BRL}}
  end

  test "new!/1 with default value set" do
    Application.put_env(:ex_dinheiro, :default_currency, :BRL)

    assert Dinheiro.new!(12345) == %Dinheiro{quantia: 1_234_500, moeda: :BRL}
  end

  test "new!/1 with an invalid default value set" do
    Application.put_env(:ex_dinheiro, :default_currency, :NONE)

    assert_raise ArgumentError, fn ->
      Dinheiro.new!(12345)
    end
  end

  test "new!/1 with no config set" do
    Application.delete_env(:ex_dinheiro, :default_currency)

    assert_raise ArgumentError, fn ->
      Dinheiro.new!(12345)
    end
  end

  test "new!/2 requires existing value" do
    assert_raise ArgumentError, fn ->
      Dinheiro.new!(12345, :NONE)
    end
  end

  test "new!/1 with float value" do
    Application.put_env(:ex_dinheiro, :default_currency, :BRL)

    assert Dinheiro.new!(123.45) == %Dinheiro{quantia: 12345, moeda: :BRL}
  end

  test "new!/1 with an invalid value" do
    Application.put_env(:ex_dinheiro, :default_currency, :BRL)

    assert_raise FunctionClauseError, fn ->
      Dinheiro.new!("1234")
    end
  end

  test "new!/2 with a float value" do
    assert Dinheiro.new!(123.45, :BRL) == %Dinheiro{quantia: 12345, moeda: :BRL}
  end

  test "new!/2 with an invalid value" do
    assert_raise FunctionClauseError, fn ->
      Dinheiro.new!("12345", :BRL)
    end
  end

  test "compare!(1" do
    assert Dinheiro.compare!(
             Dinheiro.new!(123.45, :BRL),
             Dinheiro.new!(123.45, :BRL)
           ) == 0

    assert Dinheiro.compare!(
             Dinheiro.new!(123.45, :BRL),
             Dinheiro.new!(123.46, :BRL)
           ) == -1

    assert Dinheiro.compare!(
             Dinheiro.new!(123.46, :BRL),
             Dinheiro.new!(123.45, :BRL)
           ) == 1

    assert_raise ArgumentError, fn ->
      Dinheiro.compare!(Dinheiro.new!(123.45, :BRL), %Dinheiro{
        quantia: 12345,
        moeda: :USD
      }) == 0
    end
  end

  test "equals?/2" do
    assert Dinheiro.equals?(
             Dinheiro.new!(123.45, :BRL),
             Dinheiro.new!(123.45, :BRL)
           ) == true

    assert Dinheiro.equals?(
             Dinheiro.new!(123.45, :BRL),
             Dinheiro.new!(123.46, :BRL)
           ) == false

    assert Dinheiro.equals?(
             Dinheiro.new!(123.46, :BRL),
             Dinheiro.new!(123.46, :USD)
           ) == false
  end

  test "sum!(2" do
    assert Dinheiro.sum!(Dinheiro.new!(12345, :BRL), Dinheiro.new!(12345, :BRL)) ==
             %Dinheiro{
               quantia: 2_469_000,
               moeda: :BRL
             }

    assert Dinheiro.sum!(Dinheiro.new!(1, :BRL), 1) == %Dinheiro{
             quantia: 200,
             moeda: :BRL
           }

    assert Dinheiro.sum!(Dinheiro.new!(1, :BRL), 1.2) == %Dinheiro{
             quantia: 220,
             moeda: :BRL
           }

    assert Dinheiro.sum!(Dinheiro.new!(-1, :BRL), 1.2) == %Dinheiro{
             quantia: 20,
             moeda: :BRL
           }

    assert_raise ArgumentError, fn ->
      Dinheiro.sum!(Dinheiro.new!(1, :BRL), Dinheiro.new!(1, :USD))
    end
  end

  test "subtract!(2" do
    assert Dinheiro.subtract!(Dinheiro.new!(2, :BRL), Dinheiro.new!(1, :BRL)) ==
             %Dinheiro{
               quantia: 100,
               moeda: :BRL
             }

    assert Dinheiro.subtract!(Dinheiro.new!(3, :BRL), 1) == %Dinheiro{
             quantia: 200,
             moeda: :BRL
           }

    assert Dinheiro.subtract!(Dinheiro.new!(4, :BRL), 1.2) == %Dinheiro{
             quantia: 280,
             moeda: :BRL
           }

    assert Dinheiro.subtract!(Dinheiro.new!(1, :BRL), -1) == %Dinheiro{
             quantia: 200,
             moeda: :BRL
           }

    assert_raise ArgumentError, fn ->
      Dinheiro.subtract!(Dinheiro.new!(2, :BRL), Dinheiro.new!(1, :USD))
    end
  end

  test "multiply!(2" do
    assert Dinheiro.multiply!(Dinheiro.new!(3, :BRL), 2) == %Dinheiro{
             quantia: 600,
             moeda: :BRL
           }

    assert Dinheiro.multiply!(Dinheiro.new!(4, :BRL), 1.5) == %Dinheiro{
             quantia: 600,
             moeda: :BRL
           }

    assert Dinheiro.multiply!(Dinheiro.new!(1, :BRL), -1) == %Dinheiro{
             quantia: -100,
             moeda: :BRL
           }

    assert_raise FunctionClauseError, fn ->
      Dinheiro.multiply!(2, 2)
    end

    assert_raise FunctionClauseError, fn ->
      Dinheiro.multiply!(%{quantia: 600, moeda: :BRL}, 2)
    end
  end

  test "to_float!(1" do
    assert Dinheiro.to_float!(%Dinheiro{quantia: 600, moeda: :BRL}) == 6.0
    assert Dinheiro.to_float!(%Dinheiro{quantia: 625, moeda: :BRL}) == 6.25
    assert Dinheiro.to_float!(%Dinheiro{quantia: -625, moeda: :BRL}) == -6.25

    assert_raise FunctionClauseError, fn ->
      Dinheiro.to_float!(%{quantia: 600, moeda: :BRL})
    end

    assert_raise FunctionClauseError, fn ->
      Dinheiro.to_float!(123)
    end

    assert_raise ArgumentError, fn ->
      Dinheiro.to_float!(%Dinheiro{quantia: 600, moeda: :NONE})
    end
  end

  test "to_float/2" do
    assert Dinheiro.to_float(%Dinheiro{quantia: 10_000, moeda: :BRL}) ==
             {:ok, 100.00}

    assert Dinheiro.to_float(%Dinheiro{quantia: 600, moeda: :NONE}) ==
             {:error, "'NONE' does not represent an ISO 4217 code."}
  end

  test "divide/2" do
    assert Dinheiro.divide(Dinheiro.new!(0.02, :BRL), 3) ==
             {:ok,
              [
                %Dinheiro{quantia: 1, moeda: :BRL},
                %Dinheiro{quantia: 1, moeda: :BRL},
                %Dinheiro{quantia: 0, moeda: :BRL}
              ]}

    assert Dinheiro.divide(%Dinheiro{quantia: 600, moeda: :NONE}, 3) ==
             {:error, "'NONE' does not represent an ISO 4217 code."}
  end

  test "divide!/2" do
    assert Dinheiro.divide!(Dinheiro.new!(0.02, :BRL), 3) == [
             %Dinheiro{quantia: 1, moeda: :BRL},
             %Dinheiro{quantia: 1, moeda: :BRL},
             %Dinheiro{quantia: 0, moeda: :BRL}
           ]

    assert Dinheiro.divide!(%Dinheiro{quantia: 600, moeda: :BRL}, 2) == [
             %Dinheiro{quantia: 300, moeda: :BRL},
             %Dinheiro{quantia: 300, moeda: :BRL}
           ]

    assert Dinheiro.divide!(%Dinheiro{quantia: 625, moeda: :BRL}, 2) == [
             %Dinheiro{quantia: 313, moeda: :BRL},
             %Dinheiro{quantia: 312, moeda: :BRL}
           ]

    assert Dinheiro.divide!(Dinheiro.new!(0.05, :BRL), [3, 7]) == [
             %Dinheiro{quantia: 2, moeda: :BRL},
             %Dinheiro{quantia: 3, moeda: :BRL}
           ]

    assert_raise ArgumentError, fn ->
      Dinheiro.divide!(%Dinheiro{quantia: 600, moeda: :BRL}, 0)
    end

    assert_raise ArgumentError, fn ->
      Dinheiro.divide!(%Dinheiro{quantia: 600, moeda: :BRL}, -1)
    end

    assert_raise ArgumentError, fn ->
      Dinheiro.divide!(%Dinheiro{quantia: 600, moeda: :BRL}, [-1])
    end

    assert_raise ArgumentError, fn ->
      Dinheiro.divide!(%Dinheiro{quantia: 600, moeda: :BRL}, [""])
    end

    assert_raise ArgumentError, fn ->
      Dinheiro.divide!(%Dinheiro{quantia: 600, moeda: :BRL}, [1.0])
    end

    assert_raise FunctionClauseError, fn ->
      Dinheiro.divide!(%Dinheiro{quantia: 600, moeda: :BRL}, 1.0)
    end

    assert_raise FunctionClauseError, fn ->
      Dinheiro.divide!(%{quantia: 600, moeda: :BRL}, 2)
    end
  end

  test "to_string!/2" do
    assert Dinheiro.to_string!(Dinheiro.new!(0.1, :BRL)) == "R$ 0,10"
    assert Dinheiro.to_string!(Dinheiro.new!(1.0, "BRL")) == "R$ 1,00"
    assert Dinheiro.to_string!(Dinheiro.new!(10.0, :brl)) == "R$ 10,00"
    assert Dinheiro.to_string!(Dinheiro.new!(100.0, "brl")) == "R$ 100,00"
    assert Dinheiro.to_string!(Dinheiro.new!(-1000.0, :BRL)) == "R$ -1.000,00"

    assert Dinheiro.to_string!(Dinheiro.new!(12_345_678.9, :BRL)) ==
             "R$ 12.345.678,90"

    assert Dinheiro.to_string!(
             Dinheiro.new!(12_345_678.9, :USD),
             thousand_separator: ",",
             decimal_separator: "."
           ) == "$ 12,345,678.90"

    assert_raise ArgumentError, fn ->
      Dinheiro.to_string!(%Dinheiro{quantia: 600, moeda: :NONE})
    end
  end

  test "to_string/2" do
    assert Dinheiro.to_string(%Dinheiro{quantia: 10_000, moeda: :BRL}) ==
             {:ok, "R$ 100,00"}

    assert Dinheiro.to_string(%Dinheiro{quantia: 600, moeda: :NONE}) ==
             {:error, "'NONE' does not represent an ISO 4217 code."}
  end
end
