defmodule Fab.InternetTest do
  use ExUnit.Case

  setup tags do
    Application.put_env(:fab, :seed, seed(tags))
    :ok
  end

  doctest Fab.Internet

  defp seed(tags) do
    seed =
      (File.cwd!() <> "/lib/fab/internet.ex")
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Enum.at(tags[:doctest_line] - 1)
      |> :binary.decode_unsigned()
      |> to_string()

    seed_len = String.length(seed)

    seed
    |> String.replace(~r/\d{#{seed_len - 7}}/, "")
    |> String.to_integer()
  end
end
