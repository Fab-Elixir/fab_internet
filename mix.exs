defmodule Fab.Internet.MixProject do
  use Mix.Project

  def project do
    [
      app: :fab_internet,
      description:
        "Fab.Internet is an Elixir library for generating random internet related data",
      version: "1.0.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:fab, "~> 1.1"},
      {:fab_person, "~> 1.0"},
      {:fab_word, "~> 1.0"},
      {:ex_doc, "== 0.38.1", only: :dev, runtime: false},
      {:dialyxir, "== 1.4.5", only: :dev, runtime: false}
    ]
  end

  defp package do
    %{
      authors: ["Anthony Smith"],
      licenses: ["MIT"],
      links: %{
        Fab: "https://hexdocs.pm/fab/Fab.html",
        GitHub: "https://github.com/Fab-Elixir/fab_internet"
      }
    }
  end
end
