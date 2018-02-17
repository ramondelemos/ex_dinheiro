defmodule Moeda do
  @moduledoc """
  Documentation for Moeda.
  """

  @moedas %{
    AED: %{nome: "UAE Dirham", simbolo: [], codigo: "AED", codigo_iso: 784, expoente: 2},
    AFN: %{nome: "Afghani", simbolo: [1547], codigo: "AFN", codigo_iso: 971, expoente: 2},
    ALL: %{nome: "Lek", simbolo: [76, 101, 107], codigo: "ALL", codigo_iso: 008, expoente: 2},
    AMD: %{nome: "Armenian Dram", simbolo: [], codigo: "AMD", codigo_iso: 051, expoente: 2},
    ANG: %{
      nome: "Netherlands Antillean Guilder",
      simbolo: [402],
      codigo: "ANG",
      codigo_iso: 532,
      expoente: 2
    },
    AOA: %{nome: "Kwanza", simbolo: [], codigo: "AOA", codigo_iso: 973, expoente: 2},
    ARS: %{nome: "Argentine Peso", simbolo: [36], codigo: "ARS", codigo_iso: 032, expoente: 2},
    AUD: %{nome: "Australian Dollar", simbolo: [36], codigo: "AUD", codigo_iso: 036, expoente: 2},
    AWG: %{nome: "Aruban Florin", simbolo: [402], codigo: "AWG", codigo_iso: 533, expoente: 2},
    AZN: %{nome: "Azerbaijan Manat", simbolo: [8380], codigo: "AZN", codigo_iso: 944, expoente: 2},
    BAM: %{
      nome: "Convertible Mark",
      simbolo: [75, 77],
      codigo: "BAM",
      codigo_iso: 977,
      expoente: 2
    },
    BBD: %{nome: "Barbados Dollar", simbolo: [36], codigo: "BBD", codigo_iso: 052, expoente: 2},
    BDT: %{nome: "Taka", simbolo: [], codigo: "BDT", codigo_iso: 050, expoente: 2},
    BGN: %{
      nome: "Bulgarian Lev",
      simbolo: [1083, 1074],
      codigo: "BGN",
      codigo_iso: 975,
      expoente: 2
    },
    BHD: %{nome: "Bahraini Dinar", simbolo: [], codigo: "BHD", codigo_iso: 048, expoente: 3},
    BIF: %{nome: "Burundi Franc", simbolo: [], codigo: "BIF", codigo_iso: 108, expoente: 0},
    BMD: %{nome: "Bermudian Dollar", simbolo: [36], codigo: "BMD", codigo_iso: 060, expoente: 2},
    BND: %{nome: "Brunei Dollar", simbolo: [36], codigo: "BND", codigo_iso: 096, expoente: 2},
    BOB: %{nome: "Boliviano", simbolo: [36, 98], codigo: "BOB", codigo_iso: 068, expoente: 2},
    BOV: %{nome: "Mvdol", simbolo: [], codigo: "BOV", codigo_iso: 984, expoente: 2},
    BRL: %{nome: "Brazilian Real", simbolo: [82, 36], codigo: "BRL", codigo_iso: 986, expoente: 2},
    BSD: %{nome: "Bahamian Dollar", simbolo: [36], codigo: "BSD", codigo_iso: 044, expoente: 2},
    BTN: %{nome: "Ngultrum", simbolo: [], codigo: "BTN", codigo_iso: 064, expoente: 2},
    BWP: %{nome: "Pula", simbolo: [80], codigo: "BWP", codigo_iso: 072, expoente: 2},
    BYN: %{
      nome: "Belarusian Ruble",
      simbolo: [66, 114],
      codigo: "BYN",
      codigo_iso: 933,
      expoente: 2
    },
    BZD: %{
      nome: "Belize Dollar",
      simbolo: [66, 90, 36],
      codigo: "BZD",
      codigo_iso: 084,
      expoente: 2
    },
    CAD: %{nome: "Canadian Dollar", simbolo: [36], codigo: "CAD", codigo_iso: 124, expoente: 2},
    CDF: %{nome: "Congolese Franc", simbolo: [], codigo: "CDF", codigo_iso: 976, expoente: 2},
    CHE: %{nome: "WIR Euro", simbolo: [], codigo: "CHE", codigo_iso: 947, expoente: 2},
    CHF: %{
      nome: "Swiss Franc",
      simbolo: [67, 72, 70],
      codigo: "CHF",
      codigo_iso: 756,
      expoente: 2
    },
    CHW: %{nome: "WIR Franc", simbolo: [], codigo: "CHW", codigo_iso: 948, expoente: 2},
    CLF: %{nome: "Unidad de Fomento", simbolo: [], codigo: "CLF", codigo_iso: 990, expoente: 4},
    CLP: %{nome: "Chilean Peso", simbolo: [36], codigo: "CLP", codigo_iso: 152, expoente: 0},
    CNY: %{nome: "Yuan Renminbi", simbolo: [165], codigo: "CNY", codigo_iso: 156, expoente: 2},
    COP: %{nome: "Colombian Peso", simbolo: [36], codigo: "COP", codigo_iso: 170, expoente: 2},
    COU: %{nome: "Unidad de Valor Real", simbolo: [], codigo: "COU", codigo_iso: 970, expoente: 2},
    CRC: %{
      nome: "Costa Rican Colon",
      simbolo: [8353],
      codigo: "CRC",
      codigo_iso: 188,
      expoente: 2
    },
    CUC: %{nome: "Peso Convertible", simbolo: [], codigo: "CUC", codigo_iso: 931, expoente: 2},
    CUP: %{nome: "Cuban Peso", simbolo: [8369], codigo: "CUP", codigo_iso: 192, expoente: 2},
    CVE: %{nome: "Cabo Verde Escudo", simbolo: [], codigo: "CVE", codigo_iso: 132, expoente: 2},
    CZK: %{nome: "Czech Koruna", simbolo: [75, 269], codigo: "CZK", codigo_iso: 203, expoente: 2},
    DJF: %{nome: "Djibouti Franc", simbolo: [], codigo: "DJF", codigo_iso: 262, expoente: 0},
    DKK: %{nome: "Danish Krone", simbolo: [107, 114], codigo: "DKK", codigo_iso: 208, expoente: 2},
    DOP: %{
      nome: "Dominican Peso",
      simbolo: [82, 68, 36],
      codigo: "DOP",
      codigo_iso: 214,
      expoente: 2
    },
    DZD: %{nome: "Algerian Dinar", simbolo: [], codigo: "DZD", codigo_iso: 012, expoente: 2},
    EGP: %{nome: "Egyptian Pound", simbolo: [163], codigo: "EGP", codigo_iso: 818, expoente: 2},
    ERN: %{nome: "Nakfa", simbolo: [], codigo: "ERN", codigo_iso: 232, expoente: 2},
    ETB: %{nome: "Ethiopian Birr", simbolo: [], codigo: "ETB", codigo_iso: 230, expoente: 2},
    EUR: %{nome: "Euro", simbolo: [8364], codigo: "EUR", codigo_iso: 978, expoente: 2},
    FJD: %{nome: "Fiji Dollar", simbolo: [36], codigo: "FJD", codigo_iso: 242, expoente: 2},
    FKP: %{
      nome: "Falkland Islands Pound",
      simbolo: [163],
      codigo: "FKP",
      codigo_iso: 238,
      expoente: 2
    },
    GBP: %{nome: "Pound Sterling", simbolo: [163], codigo: "GBP", codigo_iso: 826, expoente: 2},
    GEL: %{nome: "Lari", simbolo: [], codigo: "GEL", codigo_iso: 981, expoente: 2},
    GHS: %{nome: "Ghana Cedi", simbolo: [162], codigo: "GHS", codigo_iso: 936, expoente: 2},
    GIP: %{nome: "Gibraltar Pound", simbolo: [163], codigo: "GIP", codigo_iso: 292, expoente: 2},
    GMD: %{nome: "Dalasi", simbolo: [], codigo: "GMD", codigo_iso: 270, expoente: 2},
    GNF: %{nome: "Guinean Franc", simbolo: [], codigo: "GNF", codigo_iso: 324, expoente: 0},
    GTQ: %{nome: "Quetzal", simbolo: [81], codigo: "GTQ", codigo_iso: 320, expoente: 2},
    GYD: %{nome: "Guyana Dollar", simbolo: [36], codigo: "GYD", codigo_iso: 328, expoente: 2},
    HKD: %{nome: "Hong Kong Dollar", simbolo: [36], codigo: "HKD", codigo_iso: 344, expoente: 2},
    HNL: %{nome: "Lempira", simbolo: [76], codigo: "HNL", codigo_iso: 340, expoente: 2},
    HRK: %{nome: "Kuna", simbolo: [107, 11], codigo: "HRK", codigo_iso: 191, expoente: 2},
    HTG: %{nome: "Gourde", simbolo: [], codigo: "HTG", codigo_iso: 332, expoente: 2},
    HUF: %{nome: "Forint", simbolo: [70, 116], codigo: "HUF", codigo_iso: 348, expoente: 2},
    IDR: %{nome: "Rupiah", simbolo: [82, 112], codigo: "IDR", codigo_iso: 360, expoente: 2},
    ILS: %{
      nome: "New Israeli Sheqel",
      simbolo: [8362],
      codigo: "ILS",
      codigo_iso: 376,
      expoente: 2
    },
    INR: %{nome: "Indian Rupee", simbolo: [], codigo: "INR", codigo_iso: 356, expoente: 2},
    IQD: %{nome: "Iraqi Dinar", simbolo: [], codigo: "IQD", codigo_iso: 368, expoente: 3},
    IRR: %{nome: "Iranian Rial", simbolo: [65020], codigo: "IRR", codigo_iso: 364, expoente: 2},
    ISK: %{
      nome: "Iceland Krona",
      simbolo: [107, 114],
      codigo: "ISK",
      codigo_iso: 352,
      expoente: 0
    },
    JMD: %{
      nome: "Jamaican Dollar",
      simbolo: [74, 36],
      codigo: "JMD",
      codigo_iso: 388,
      expoente: 2
    },
    JOD: %{nome: "Jordanian Dinar", simbolo: [], codigo: "JOD", codigo_iso: 400, expoente: 3},
    JPY: %{nome: "Yen", simbolo: [165], codigo: "JPY", codigo_iso: 392, expoente: 0},
    KES: %{nome: "Kenyan Shilling", simbolo: [], codigo: "KES", codigo_iso: 404, expoente: 2},
    KGS: %{nome: "Som", simbolo: [1083, 1074], codigo: "KGS", codigo_iso: 417, expoente: 2},
    KHR: %{nome: "Riel", simbolo: [6107], codigo: "KHR", codigo_iso: 116, expoente: 2},
    KMF: %{nome: "Comorian Franc ", simbolo: [], codigo: "KMF", codigo_iso: 174, expoente: 0},
    KPW: %{nome: "North Korean Won", simbolo: [8361], codigo: "KPW", codigo_iso: 408, expoente: 2},
    KRW: %{nome: "Won", simbolo: [8361], codigo: "KRW", codigo_iso: 410, expoente: 0},
    KWD: %{nome: "Kuwaiti Dinar", simbolo: [], codigo: "KWD", codigo_iso: 414, expoente: 3},
    KYD: %{
      nome: "Cayman Islands Dollar",
      simbolo: [36],
      codigo: "KYD",
      codigo_iso: 136,
      expoente: 2
    },
    KZT: %{nome: "Tenge", simbolo: [1083, 1074], codigo: "KZT", codigo_iso: 398, expoente: 2},
    LAK: %{nome: "Lao Kip", simbolo: [8365], codigo: "LAK", codigo_iso: 418, expoente: 2},
    LBP: %{nome: "Lebanese Pound", simbolo: [163], codigo: "LBP", codigo_iso: 422, expoente: 2},
    LKR: %{nome: "Sri Lanka Rupee", simbolo: [8360], codigo: "LKR", codigo_iso: 144, expoente: 2},
    LRD: %{nome: "Liberian Dollar", simbolo: [36], codigo: "LRD", codigo_iso: 430, expoente: 2},
    LSL: %{nome: "Loti", simbolo: [], codigo: "LSL", codigo_iso: 426, expoente: 2},
    LYD: %{nome: "Libyan Dinar", simbolo: [], codigo: "LYD", codigo_iso: 434, expoente: 3},
    MAD: %{nome: "Moroccan Dirham", simbolo: [], codigo: "MAD", codigo_iso: 504, expoente: 2},
    MDL: %{nome: "Moldovan Leu", simbolo: [], codigo: "MDL", codigo_iso: 498, expoente: 2},
    MGA: %{nome: "Malagasy Ariary", simbolo: [], codigo: "MGA", codigo_iso: 969, expoente: 2},
    MKD: %{
      nome: "Denar",
      simbolo: [1076, 1077, 1085],
      codigo: "MKD",
      codigo_iso: 807,
      expoente: 2
    },
    MMK: %{nome: "Kyat", simbolo: [], codigo: "MMK", codigo_iso: 104, expoente: 2},
    MNT: %{nome: "Tugrik", simbolo: [8366], codigo: "MNT", codigo_iso: 496, expoente: 2},
    MOP: %{nome: "Pataca", simbolo: [], codigo: "MOP", codigo_iso: 446, expoente: 2},
    MRU: %{nome: "Ouguiya", simbolo: [], codigo: "MRU", codigo_iso: 929, expoente: 2},
    MUR: %{nome: "Mauritius Rupee", simbolo: [8360], codigo: "MUR", codigo_iso: 480, expoente: 2},
    MVR: %{nome: "Rufiyaa", simbolo: [], codigo: "MVR", codigo_iso: 462, expoente: 2},
    MWK: %{nome: "Malawi Kwacha", simbolo: [], codigo: "MWK", codigo_iso: 454, expoente: 2},
    MXN: %{nome: "Mexican Peso", simbolo: [36], codigo: "MXN", codigo_iso: 484, expoente: 2},
    MXV: %{
      nome: "Mexican Unidad de Inversion (UDI)",
      simbolo: [],
      codigo: "MXV",
      codigo_iso: 979,
      expoente: 2
    },
    MYR: %{
      nome: "Malaysian Ringgit",
      simbolo: [82, 77],
      codigo: "MYR",
      codigo_iso: 458,
      expoente: 2
    },
    MZN: %{
      nome: "Mozambique Metical",
      simbolo: [77, 84],
      codigo: "MZN",
      codigo_iso: 943,
      expoente: 2
    },
    NAD: %{nome: "Namibia Dollar", simbolo: [36], codigo: "NAD", codigo_iso: 516, expoente: 2},
    NGN: %{nome: "Naira", simbolo: [8358], codigo: "NGN", codigo_iso: 566, expoente: 2},
    NIO: %{nome: "Cordoba Oro", simbolo: [67, 36], codigo: "NIO", codigo_iso: 558, expoente: 2},
    NOK: %{
      nome: "Norwegian Krone",
      simbolo: [107, 114],
      codigo: "NOK",
      codigo_iso: 578,
      expoente: 2
    },
    NPR: %{nome: "Nepalese Rupee", simbolo: [8360], codigo: "NPR", codigo_iso: 524, expoente: 2},
    NZD: %{nome: "New Zealand Dollar", simbolo: [36], codigo: "NZD", codigo_iso: 554, expoente: 2},
    OMR: %{nome: "Rial Omani", simbolo: [65020], codigo: "OMR", codigo_iso: 512, expoente: 3},
    PAB: %{nome: "Balboa", simbolo: [66, 47, 46], codigo: "PAB", codigo_iso: 590, expoente: 2},
    PEN: %{nome: "Sol", simbolo: [83, 47, 46], codigo: "PEN", codigo_iso: 604, expoente: 2},
    PGK: %{nome: "Kina", simbolo: [], codigo: "PGK", codigo_iso: 598, expoente: 2},
    PHP: %{nome: "Philippine Piso", simbolo: [8369], codigo: "PHP", codigo_iso: 608, expoente: 2},
    PKR: %{nome: "Pakistan Rupee", simbolo: [8360], codigo: "PKR", codigo_iso: 586, expoente: 2},
    PLN: %{nome: "Zloty", simbolo: [122, 322], codigo: "PLN", codigo_iso: 985, expoente: 2},
    PYG: %{nome: "Guarani", simbolo: [71, 115], codigo: "PYG", codigo_iso: 600, expoente: 0},
    QAR: %{nome: "Qatari Rial", simbolo: [65020], codigo: "QAR", codigo_iso: 634, expoente: 2},
    RON: %{
      nome: "Romanian Leu",
      simbolo: [108, 101, 105],
      codigo: "RON",
      codigo_iso: 946,
      expoente: 2
    },
    RSD: %{
      nome: "Serbian Dinar",
      simbolo: [1044, 1080, 1085, 46],
      codigo: "RSD",
      codigo_iso: 941,
      expoente: 2
    },
    RUB: %{nome: "Russian Ruble", simbolo: [8381], codigo: "RUB", codigo_iso: 643, expoente: 2},
    RWF: %{nome: "Rwanda Franc", simbolo: [], codigo: "RWF", codigo_iso: 646, expoente: 0},
    SAR: %{nome: "Saudi Riyal", simbolo: [65020], codigo: "SAR", codigo_iso: 682, expoente: 2},
    SBD: %{
      nome: "Solomon Islands Dollar",
      simbolo: [36],
      codigo: "SBD",
      codigo_iso: 090,
      expoente: 2
    },
    SCR: %{nome: "Seychelles Rupee", simbolo: [8360], codigo: "SCR", codigo_iso: 690, expoente: 2},
    SDG: %{nome: "Sudanese Pound", simbolo: [], codigo: "SDG", codigo_iso: 938, expoente: 2},
    SEK: %{
      nome: "Swedish Krona",
      simbolo: [107, 114],
      codigo: "SEK",
      codigo_iso: 752,
      expoente: 2
    },
    SGD: %{nome: "Singapore Dollar", simbolo: [36], codigo: "SGD", codigo_iso: 702, expoente: 2},
    SHP: %{
      nome: "Saint Helena Pound",
      simbolo: [163],
      codigo: "SHP",
      codigo_iso: 654,
      expoente: 2
    },
    SLL: %{nome: "Leone", simbolo: [], codigo: "SLL", codigo_iso: 694, expoente: 2},
    SOS: %{nome: "Somali Shilling", simbolo: [83], codigo: "SOS", codigo_iso: 706, expoente: 2},
    SRD: %{nome: "Surinam Dollar", simbolo: [36], codigo: "SRD", codigo_iso: 968, expoente: 2},
    SSP: %{nome: "South Sudanese Pound", simbolo: [], codigo: "SSP", codigo_iso: 728, expoente: 2},
    STN: %{nome: "Dobra", simbolo: [], codigo: "STN", codigo_iso: 930, expoente: 2},
    SVC: %{nome: "El Salvador Colon", simbolo: [36], codigo: "SVC", codigo_iso: 222, expoente: 2},
    SYP: %{nome: "Syrian Pound", simbolo: [163], codigo: "SYP", codigo_iso: 760, expoente: 2},
    SZL: %{nome: "Lilangeni", simbolo: [], codigo: "SZL", codigo_iso: 748, expoente: 2},
    THB: %{nome: "Baht", simbolo: [3647], codigo: "THB", codigo_iso: 764, expoente: 2},
    TJS: %{nome: "Somoni", simbolo: [], codigo: "TJS", codigo_iso: 972, expoente: 2},
    TMT: %{
      nome: "Turkmenistan New Manat",
      simbolo: [],
      codigo: "TMT",
      codigo_iso: 934,
      expoente: 2
    },
    TND: %{nome: "Tunisian Dinar", simbolo: [], codigo: "TND", codigo_iso: 788, expoente: 3},
    TOP: %{nome: "Pa’anga", simbolo: [], codigo: "TOP", codigo_iso: 776, expoente: 2},
    TRY: %{nome: "Turkish Lira", simbolo: [], codigo: "TRY", codigo_iso: 949, expoente: 2},
    TTD: %{
      nome: "Trinidad and Tobago Dollar",
      simbolo: [84, 84, 36],
      codigo: "TTD",
      codigo_iso: 780,
      expoente: 2
    },
    TWD: %{
      nome: "New Taiwan Dollar",
      simbolo: [78, 84, 36],
      codigo: "TWD",
      codigo_iso: 901,
      expoente: 2
    },
    TZS: %{nome: "Tanzanian Shilling", simbolo: [], codigo: "TZS", codigo_iso: 834, expoente: 2},
    UAH: %{nome: "Hryvnia", simbolo: [8372], codigo: "UAH", codigo_iso: 980, expoente: 2},
    UGX: %{nome: "Uganda Shilling", simbolo: [], codigo: "UGX", codigo_iso: 800, expoente: 0},
    USD: %{nome: "US Dollar", simbolo: [36], codigo: "USD", codigo_iso: 840, expoente: 2},
    USN: %{nome: "US Dollar (Next day)", simbolo: [], codigo: "USN", codigo_iso: 997, expoente: 2},
    UYI: %{
      nome: "Uruguay Peso en Unidades Indexadas (URUIURUI)",
      simbolo: [],
      codigo: "UYI",
      codigo_iso: 940,
      expoente: 0
    },
    UYU: %{nome: "Peso Uruguayo", simbolo: [36, 85], codigo: "UYU", codigo_iso: 858, expoente: 2},
    UZS: %{
      nome: "Uzbekistan Sum",
      simbolo: [1083, 1074],
      codigo: "UZS",
      codigo_iso: 860,
      expoente: 2
    },
    VEF: %{nome: "Bolívar", simbolo: [66, 115], codigo: "VEF", codigo_iso: 937, expoente: 2},
    VND: %{nome: "Dong", simbolo: [8363], codigo: "VND", codigo_iso: 704, expoente: 0},
    VUV: %{nome: "Vatu", simbolo: [], codigo: "VUV", codigo_iso: 548, expoente: 0},
    WST: %{nome: "Tala", simbolo: [], codigo: "WST", codigo_iso: 882, expoente: 2},
    XAF: %{nome: "CFA Franc BEAC", simbolo: [], codigo: "XAF", codigo_iso: 950, expoente: 0},
    XCD: %{
      nome: "East Caribbean Dollar",
      simbolo: [36],
      codigo: "XCD",
      codigo_iso: 951,
      expoente: 2
    },
    XOF: %{nome: "CFA Franc BCEAO", simbolo: [], codigo: "XOF", codigo_iso: 952, expoente: 0},
    XPF: %{nome: "CFP Franc", simbolo: [], codigo: "XPF", codigo_iso: 953, expoente: 0},
    YER: %{nome: "Yemeni Rial", simbolo: [65020], codigo: "YER", codigo_iso: 886, expoente: 2},
    ZAR: %{nome: "Rand", simbolo: [82], codigo: "ZAR", codigo_iso: 710, expoente: 2},
    ZMW: %{nome: "Zambian Kwacha", simbolo: [], codigo: "ZMW", codigo_iso: 967, expoente: 2},
    ZWL: %{nome: "Zimbabwe Dollar", simbolo: [], codigo: "ZWL", codigo_iso: 932, expoente: 2}
  }

  @spec find(String.t() | atom) :: map | nil
  @doc """
  Return a map from an atom or string that represents an ISO 4217 code.

  ## Examples

      iex> Moeda.find(:BRL)
      %{nome: "Brazilian Real", simbolo: 'R$', codigo: "BRL", codigo_iso: 986, expoente: 2}
      iex> Moeda.find("BRL")
      %{nome: "Brazilian Real", simbolo: 'R$', codigo: "BRL", codigo_iso: 986, expoente: 2}
      iex> Moeda.find("")
      nil

  Its function ignore case sensitive.

  ## Examples

      iex> Moeda.find(:brl)
      %{nome: "Brazilian Real", simbolo: 'R$', codigo: "BRL", codigo_iso: 986, expoente: 2}
      iex> Moeda.find("brl")
      %{nome: "Brazilian Real", simbolo: 'R$', codigo: "BRL", codigo_iso: 986, expoente: 2}

  """
  def find(codigo) when is_atom(codigo) do
    codigo
    |> Atom.to_string()
    |> String.upcase()
    |> String.to_atom()
    |> findp
  end

  def find(codigo) when is_binary(codigo) do
    codigo
    |> String.upcase()
    |> String.to_atom()
    |> findp
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

  @spec to_string(String.t() | atom, float, Keywords.t()) :: String.t()
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

    - `thousand_separator` - default `"."`, set the thousand separator.
    - `decimal_separator` - default `","`, set the decimal separator.
    - `display_currency_symbol` - default `true`, put to `false` to hide de currency symbol.
    - `display_currency_code` - default `false`, put to `true` to display de currency ISO 4217 code.

  ## Exemples

      iex> Moeda.to_string(:USD, 1000.5, thousand_separator: ",", decimal_separator: ".")
      "$ 1,000.50"
      iex> Moeda.to_string(:USD, 1000.5, display_currency_symbol: false)
      "1.000,50"
      iex> Moeda.to_string(:USD, 1000.5, display_currency_code: true)
      "$ 1.000,50 USD"
      iex> Moeda.to_string(:USD, 1000.5, display_currency_code: true, display_currency_symbol: false)
      "1.000,50 USD"

  The default values also can be set in the system Mix config.

  ## Example:
      iex> Application.put_env(:ex_dinheiro, :thousand_separator, ",")
      iex> Application.put_env(:ex_dinheiro, :decimal_separator, ".")
      iex> Moeda.to_string(:USD, 1000.5)
      "$ 1,000.50"
      iex> Application.put_env(:ex_dinheiro, :display_currency_symbol, false)
      iex> Moeda.to_string(:USD, 5000.5)
      "5,000.50"
      iex> Application.put_env(:ex_dinheiro, :display_currency_code, true)
      iex> Moeda.to_string(:USD, 10000.0)
      "10,000.00 USD"

  The options-style parameters override values in the system Mix config.

  ## Example:
      iex> Application.put_env(:ex_dinheiro, :thousand_separator, ",")
      iex> Application.put_env(:ex_dinheiro, :decimal_separator, ".")
      iex> Moeda.to_string(:USD, 1000.5)
      "$ 1,000.50"
      iex> Moeda.to_string(:BRL, 1000.5, thousand_separator: ".", decimal_separator: ",")
      "R$ 1.000,50"

  """
  def to_string(moeda, valor, opts \\ []) do
    m = Moeda.find(moeda)

    unless m, do: raise(ArgumentError, message: "'#{moeda}' does not represent an ISO 4217 code.")

    unless is_float(valor), do: raise(ArgumentError, message: "Value '#{valor}' must be float.")

    conf_thousand_separator = Application.get_env(:ex_dinheiro, :thousand_separator, ".")
    conf_decimal_separator = Application.get_env(:ex_dinheiro, :decimal_separator, ",")

    conf_display_currency_symbol =
      Application.get_env(:ex_dinheiro, :display_currency_symbol, true)

    conf_display_currency_code = Application.get_env(:ex_dinheiro, :display_currency_code, false)

    thousand_separator = Keyword.get(opts, :thousand_separator, conf_thousand_separator)
    decimal_separator = Keyword.get(opts, :decimal_separator, conf_decimal_separator)

    display_currency_symbol =
      Keyword.get(opts, :display_currency_symbol, conf_display_currency_symbol)

    display_currency_code = Keyword.get(opts, :display_currency_code, conf_display_currency_code)

    parts =
      valor
      |> :erlang.float_to_binary(decimals: m.expoente)
      |> String.split(".")

    thousands =
      parts
      |> List.first()
      |> String.reverse()
      |> String.codepoints()
      |> format_thousands(thousand_separator)
      |> String.reverse()

    decimals =
      if m.expoente > 0 do
        Enum.join([decimal_separator, List.last(parts)])
      else
        ""
      end

    currency_symbol =
      if display_currency_symbol do
        m.simbolo
      else
        ""
      end

    currency_code =
      if display_currency_code do
        m.codigo
      else
        ""
      end

    [currency_symbol, " ", thousands, decimals, " ", currency_code]
    |> Enum.join()
    |> String.trim()
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
