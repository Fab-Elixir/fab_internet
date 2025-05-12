defmodule Fab.Internet do
  @moduledoc """
  Functions for generating random internet related data.
  """

  import Fab.Locale
  import Fab.Randomizer

  @callback tld() ::
              [String.t()]

  @optional_callbacks [
    tld: 0
  ]

  @doc """
  Generates a random domain name.

  ## Examples

      iex> Fab.Internet.domain_name()
      "interchange.tel"
  """
  @doc since: "1.0.0"
  @spec domain_name :: String.t()
  def domain_name do
    sld =
      [
        Fab.Word.adjective(),
        Fab.Word.noun()
      ]
      |> random()

    "#{sld}.#{tld()}"
  end

  @doc """
  Generates a random email address.

  The email address is constructed from a generated username and a domain name,
  separated by `@`.

  ## Options

  - `:case` - Case format of the username. Can be `:any`, `:lower`, `:mixed` or
    `:upper`. Defaults to `:any`.
  - `:first_name` - First name to use. Defaults to a randomly generated name
    based on `:sex`.
  - `:last_name` - Last name to use. Defaults to a randomly generated name
    based on `:sex`.
  - `:sex` - Sex used to generate the first and last name. Can be `:female`,
    `:male` or `:mixed`. Defaults to `:mixed`.

  ## Examples

      iex> Fab.Internet.email_address()
      "tiana.goodwin68@mountain.courses"

      iex> Fab.Internet.email_address(case: :lower)
      "marian_waelchi76@confusion.solutions"

      iex> Fab.Internet.email_address(case: :mixed)
      "Delores_Konopelski@orchid.voting"

      iex> Fab.Internet.email_address(case: :upper)
      "CIERRA_GISLASON@LIVE.MEME"

      iex> Fab.Internet.email_address(first_name: "Anthony")
      "ANTHONY_WARD62@PHRASE.WIKI"

      iex> Fab.Internet.email_address(last_name: "Smith")
      "selina.smith8@empty.mil"

      iex> Fab.Internet.email_address(sex: :female)
      "peggy_kemmer@boyfriend.center"

      iex> Fab.Internet.email_address(sex: :male)
      "SAUL_VANDERVORT13@CIRCULAR.REVIEW"
  """
  @doc since: "1.0.0"
  @spec email_address(keyword) :: String.t()
  def email_address(opts \\ []) do
    case = Keyword.get(opts, :case, :any)

    username =
      opts
      |> username()
      |> String.replace(~r/[^A-Za-z0-9._+-]+/, "")
      |> String.replace(~r/\.{2,}/, ".")
      |> String.replace(~r/^\./, "")
      |> String.replace(~r/\.$/, "")

    casing("#{username}@#{domain_name()}", case)
  end

  @doc """
  Returns a random HTTP method.

  ## Examples

      iex> Fab.Internet.http_method()
      "PUT"
  """
  @doc since: "1.0.0"
  @spec http_method :: String.t()
  def http_method do
    [
      "CONNECT",
      "GET",
      "DELETE",
      "HEAD",
      "OPTIONS",
      "PATCH",
      "POST",
      "PUT",
      "TRACE"
    ]
    |> random()
  end

  @doc """
  Returns a random HTTP status code.

  ## Examples

      iex> Fab.Internet.http_status_code()
      502
  """
  @doc since: "1.0.0"
  @spec http_status_code(keyword) :: pos_integer
  def http_status_code(opts \\ []) do
    status_codes =
      %{
        client_error: [
          400,
          401,
          402,
          403,
          404,
          405,
          406,
          407,
          408,
          409,
          410,
          411,
          412,
          413,
          414,
          415,
          416,
          417,
          418,
          421,
          422,
          423,
          424,
          425,
          426,
          428,
          429,
          431
        ],
        info: [
          100,
          101,
          102,
          103
        ],
        redirect: [
          300,
          301,
          302,
          303,
          304,
          305,
          306,
          307,
          308
        ],
        server_error: [
          500,
          501,
          502,
          503,
          504,
          505,
          506,
          507,
          508,
          510,
          511
        ],
        success: [
          200,
          201,
          202,
          203,
          204,
          205,
          206,
          207,
          208,
          226
        ]
      }

    opts
    |> Keyword.get(:types, [:client_error, :info, :redirect, :server_error, :success])
    |> Enum.reduce([], fn type, acc ->
      acc ++ status_codes[type]
    end)
    |> random()
  end

  @doc """
  Generates a random IPv4 or IPv6 address.

  ## Examples

      iex> Fab.Internet.ip()
      "4b1c:e71c:9b7d:66a5:b1ff:c34:a2dd:533e"
  """
  @doc since: "1.0.0"
  @spec ip :: String.t()
  def ip do
    [
      ipv4(),
      ipv6()
    ]
    |> random()
  end

  @doc """
  Generates a random IPv4 address.

  ## Examples

      iex> Fab.Internet.ipv4()
      "110.105.64.36"
  """
  @doc since: "1.0.0"
  @spec ipv4 :: String.t()
  def ipv4 do
    Enum.map(1..4, fn _ ->
      Fab.Number.integer(min: 0, max: 255)
    end)
    |> Enum.join(".")
  end

  @doc """
  Generates a random IPv6 address.

  ## Examples

      iex> Fab.Internet.ipv6()
      "2a98:473b:9ee0:17b4:4352:2f7b:38bb:809b"
  """
  @doc since: "1.0.0"
  @spec ipv6 :: String.t()
  def ipv6 do
    Enum.map(1..8, fn _ ->
      Fab.Number.hex(65536)
    end)
    |> Enum.join(":")
    |> String.downcase()
  end

  @doc """
  Returns a random port number.

  ## Examples

      iex> Fab.Internet.port()
      32497
  """
  @doc since: "1.0.0"
  @spec port :: pos_integer
  def port do
    Fab.Number.integer(65535)
  end

  @doc """
  Generates a random URL.

  ## Examples

      iex> Fab.Internet.url()
      "https://desk.bio"
  """
  @doc since: "1.0.0"
  @spec url :: String.t()
  def url do
    protocol = random(["http", "https"])

    "#{protocol}://#{domain_name()}"
  end

  @doc """
  Generates a random username.

  A username is a combination of a person's first name and last name, joined by
  a randomly chosen separator (`_` or `.`). A numeric disambiguator may also be
  appended to the username.

  ## Options

  - `:case` - Case format of the username. Can be `:any`, `:lower`, `:mixed` or
    `:upper`. Defaults to `:any`.
  - `:first_name` - First name to use. Defaults to a randomly generated name
    based on `:sex`.
  - `:last_name` - Last name to use. Defaults to a randomly generated name
    based on `:sex`.
  - `:sex` - Sex used to generate the first and last name. Can be `:female`,
    `:male` or `:mixed`. Defaults to `:mixed`.

  ## Examples

      iex> Fab.Internet.username()
      "JUNE_BRADTKE56"

      iex> Fab.Internet.username(case: :lower)
      "eloise.beatty1"

      iex> Fab.Internet.username(case: :mixed)
      "Wiley_Ruecker"

      iex> Fab.Internet.username(case: :upper)
      "JAYLIN_ERDMAN63"

      iex> Fab.Internet.username(first_name: "Anthony")
      "Anthony.Okuneva"

      iex> Fab.Internet.username(last_name: "Smith")
      "Christine.Smith"

      iex> Fab.Internet.username(sex: :female)
      "ernestine.crooks"

      iex> Fab.Internet.username(sex: :male)
      "Manuel.Mraz57"
  """
  @doc since: "1.0.0"
  @spec username(keyword) :: String.t()
  def username(opts \\ []) do
    case = Keyword.get(opts, :case, :any)
    sex = Keyword.get(opts, :sex, :mixed)

    first_name = Keyword.get(opts, :first_name, Fab.Person.first_name(sex: sex))
    separator = Fab.String.from_characters(["_", "."])
    last_name = Keyword.get(opts, :last_name, Fab.Person.last_name(sex: sex))
    disambiguator = Fab.Number.integer(99)

    pattern =
      [
        "#{first_name}#{separator}#{last_name}#{disambiguator}",
        "#{first_name}#{separator}#{last_name}"
      ]
      |> random()

    pattern
    |> String.normalize(:nfkd)
    |> String.replace(~r/[\x{0300}-\x{036F}]/u, "")
    |> String.replace("'", "")
    |> String.replace(" ", "")
    |> casing(case)
  end

  @spec casing(String.t(), :lower | :mixed | :upper) :: String.t()
  defp casing(string, case) do
    case case do
      :any ->
        case = Enum.random([:lower, :mixed, :upper])
        casing(string, case)

      :lower ->
        String.downcase(string)

      :mixed ->
        string

      :upper ->
        String.upcase(string)
    end
  end

  @doc """
  Returns a random TLD.

  ## Examples

      iex> Fab.Internet.tld()
      "living"
  """
  @doc since: "1.0.0"
  @spec tld :: String.t()
  def tld do
    __MODULE__
    |> localize(:tld, [])
    |> random()
  end
end
