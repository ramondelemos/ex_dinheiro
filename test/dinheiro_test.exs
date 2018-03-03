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
              "you must set a default value in your application config :ex_dinheiro, default_currency"}

    Application.put_env(:ex_dinheiro, :default_currency, :BRL)

    assert Dinheiro.new(12345) ==
             {:ok, %Dinheiro{amount: 1_234_500, currency: :BRL}}
  end

  test "new!/1 with default value set" do
    Application.put_env(:ex_dinheiro, :default_currency, :BRL)

    assert Dinheiro.new!(12345) == %Dinheiro{amount: 1_234_500, currency: :BRL}
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

    assert Dinheiro.new!(123.45) == %Dinheiro{amount: 12345, currency: :BRL}
  end

  test "new!/1 with an invalid value" do
    Application.put_env(:ex_dinheiro, :default_currency, :BRL)

    assert_raise ArgumentError, fn ->
      Dinheiro.new!("1234")
    end
  end

  test "new/2" do
    assert Dinheiro.new(12345, :NONE) ==
             {:error, "'NONE' does not represent an ISO 4217 code"}

    assert Dinheiro.new(12345, :BRL) ==
             {:ok, %Dinheiro{amount: 1_234_500, currency: :BRL}}
  end

  test "new!/2 with a float value" do
    assert Dinheiro.new!(123.45, :BRL) == %Dinheiro{
             amount: 12345,
             currency: :BRL
           }
  end

  test "new!/2 with an invalid value" do
    assert_raise ArgumentError, fn ->
      Dinheiro.new!("12345", :BRL)
    end
  end

  test "compare/1" do
    assert Dinheiro.compare(
             Dinheiro.new!(123.45, :BRL),
             Dinheiro.new!(123.45, :BRL)
           ) == {:ok, 0}

    assert Dinheiro.compare(
             Dinheiro.new!(123.45, :USD),
             Dinheiro.new!(123.45, :BRL)
           ) == {:error, "currency :BRL must be the same as :USD"}
  end

  test "compare!/1" do
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
        amount: 12345,
        currency: :USD
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

  test "sum/2" do
    assert Dinheiro.sum(Dinheiro.new!(2, :BRL), Dinheiro.new!(1, :BRL)) ==
             {:ok,
              %Dinheiro{
                amount: 300,
                currency: :BRL
              }}

    assert Dinheiro.sum(%Dinheiro{amount: 100, currency: :NONE}, 2) ==
             {:error, "'NONE' does not represent an ISO 4217 code"}
  end

  test "sum!(2" do
    assert Dinheiro.sum!(Dinheiro.new!(12345, :BRL), Dinheiro.new!(12345, :BRL)) ==
             %Dinheiro{
               amount: 2_469_000,
               currency: :BRL
             }

    assert Dinheiro.sum!(Dinheiro.new!(1, :BRL), 1) == %Dinheiro{
             amount: 200,
             currency: :BRL
           }

    assert Dinheiro.sum!(Dinheiro.new!(1, :BRL), 1.2) == %Dinheiro{
             amount: 220,
             currency: :BRL
           }

    assert Dinheiro.sum!(Dinheiro.new!(-1, :BRL), 1.2) == %Dinheiro{
             amount: 20,
             currency: :BRL
           }

    assert_raise ArgumentError, fn ->
      Dinheiro.sum!(Dinheiro.new!(1, :BRL), Dinheiro.new!(1, :USD))
    end
  end

  test "subtract/2" do
    assert Dinheiro.subtract(Dinheiro.new!(2, :BRL), Dinheiro.new!(1, :BRL)) ==
             {:ok,
              %Dinheiro{
                amount: 100,
                currency: :BRL
              }}

    assert Dinheiro.subtract(%Dinheiro{amount: 100, currency: :NONE}, 2) ==
             {:error, "'NONE' does not represent an ISO 4217 code"}
  end

  test "subtract!(2" do
    assert Dinheiro.subtract!(Dinheiro.new!(2, :BRL), Dinheiro.new!(1, :BRL)) ==
             %Dinheiro{
               amount: 100,
               currency: :BRL
             }

    assert Dinheiro.subtract!(Dinheiro.new!(3, :BRL), 1) == %Dinheiro{
             amount: 200,
             currency: :BRL
           }

    assert Dinheiro.subtract!(Dinheiro.new!(4, :BRL), 1.2) == %Dinheiro{
             amount: 280,
             currency: :BRL
           }

    assert Dinheiro.subtract!(Dinheiro.new!(1, :BRL), -1) == %Dinheiro{
             amount: 200,
             currency: :BRL
           }

    assert_raise ArgumentError, fn ->
      Dinheiro.subtract!(Dinheiro.new!(2, :BRL), Dinheiro.new!(1, :USD))
    end
  end

  test "multiply/2" do
    assert Dinheiro.multiply(Dinheiro.new!(3, :BRL), 2) ==
             {:ok,
              %Dinheiro{
                amount: 600,
                currency: :BRL
              }}

    assert Dinheiro.multiply(2, 2) ==
             {:error, "the first param must be a Dinheiro struct"}
  end

  test "multiply!/2" do
    assert Dinheiro.multiply!(Dinheiro.new!(3, :BRL), 2) == %Dinheiro{
             amount: 600,
             currency: :BRL
           }

    assert Dinheiro.multiply!(Dinheiro.new!(4, :BRL), 1.5) == %Dinheiro{
             amount: 600,
             currency: :BRL
           }

    assert Dinheiro.multiply!(Dinheiro.new!(1, :BRL), -1) == %Dinheiro{
             amount: -100,
             currency: :BRL
           }

    assert_raise ArgumentError, fn ->
      Dinheiro.multiply!(2, 2)
    end

    assert_raise ArgumentError, fn ->
      Dinheiro.multiply!(%{amount: 600, currency: :BRL}, 2)
    end
  end

  test "to_float!(1" do
    assert Dinheiro.to_float!(%Dinheiro{amount: 600, currency: :BRL}) == 6.0
    assert Dinheiro.to_float!(%Dinheiro{amount: 625, currency: :BRL}) == 6.25
    assert Dinheiro.to_float!(%Dinheiro{amount: -625, currency: :BRL}) == -6.25

    assert_raise FunctionClauseError, fn ->
      Dinheiro.to_float!(%{amount: 600, currency: :BRL})
    end

    assert_raise FunctionClauseError, fn ->
      Dinheiro.to_float!(123)
    end

    assert_raise ArgumentError, fn ->
      Dinheiro.to_float!(%Dinheiro{amount: 600, currency: :NONE})
    end
  end

  test "to_float/2" do
    assert Dinheiro.to_float(%Dinheiro{amount: 10_000, currency: :BRL}) ==
             {:ok, 100.00}

    assert Dinheiro.to_float(%Dinheiro{amount: 600, currency: :NONE}) ==
             {:error, "'NONE' does not represent an ISO 4217 code"}
  end

  test "divide/2" do
    assert Dinheiro.divide(Dinheiro.new!(0.02, :BRL), 3) ==
             {:ok,
              [
                %Dinheiro{amount: 1, currency: :BRL},
                %Dinheiro{amount: 1, currency: :BRL},
                %Dinheiro{amount: 0, currency: :BRL}
              ]}

    assert Dinheiro.divide(%Dinheiro{amount: 600, currency: :NONE}, 3) ==
             {:error, "'NONE' does not represent an ISO 4217 code"}
  end

  test "divide!/2" do
    assert Dinheiro.divide!(Dinheiro.new!(0.02, :BRL), 3) == [
             %Dinheiro{amount: 1, currency: :BRL},
             %Dinheiro{amount: 1, currency: :BRL},
             %Dinheiro{amount: 0, currency: :BRL}
           ]

    assert Dinheiro.divide!(%Dinheiro{amount: 600, currency: :BRL}, 2) == [
             %Dinheiro{amount: 300, currency: :BRL},
             %Dinheiro{amount: 300, currency: :BRL}
           ]

    assert Dinheiro.divide!(%Dinheiro{amount: 625, currency: :BRL}, 2) == [
             %Dinheiro{amount: 313, currency: :BRL},
             %Dinheiro{amount: 312, currency: :BRL}
           ]

    assert Dinheiro.divide!(Dinheiro.new!(0.05, :BRL), [3, 7]) == [
             %Dinheiro{amount: 2, currency: :BRL},
             %Dinheiro{amount: 3, currency: :BRL}
           ]

    assert_raise ArgumentError, fn ->
      Dinheiro.divide!(%Dinheiro{amount: 600, currency: :BRL}, 0)
    end

    assert_raise ArgumentError, fn ->
      Dinheiro.divide!(%Dinheiro{amount: 600, currency: :BRL}, -1)
    end

    assert_raise ArgumentError, fn ->
      Dinheiro.divide!(%Dinheiro{amount: 600, currency: :BRL}, [-1])
    end

    assert_raise ArgumentError, fn ->
      Dinheiro.divide!(%Dinheiro{amount: 600, currency: :BRL}, [""])
    end

    assert_raise ArgumentError, fn ->
      Dinheiro.divide!(%Dinheiro{amount: 600, currency: :BRL}, [1.0])
    end

    assert_raise FunctionClauseError, fn ->
      Dinheiro.divide!(%Dinheiro{amount: 600, currency: :BRL}, 1.0)
    end

    assert_raise FunctionClauseError, fn ->
      Dinheiro.divide!(%{amount: 600, currency: :BRL}, 2)
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
      Dinheiro.to_string!(%Dinheiro{amount: 600, currency: :NONE})
    end
  end

  test "to_string/2" do
    assert Dinheiro.is_dinheiro?(%Dinheiro{amount: 200, currency: :BRL}) == true
    assert Dinheiro.is_dinheiro?(%{amount: 200, currency: :BRL}) == false
    assert Dinheiro.is_dinheiro?(200) == false
  end

  test "is_dinheiro?/1" do
    assert Dinheiro.to_string(%Dinheiro{amount: 10_000, currency: :BRL}) ==
             {:ok, "R$ 100,00"}

    assert Dinheiro.to_string(%Dinheiro{amount: 600, currency: :NONE}) ==
             {:error, "'NONE' does not represent an ISO 4217 code"}
  end
end
