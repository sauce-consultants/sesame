defmodule Sesame.Mixfile do
  use Mix.Project

  def project do
    [app: :sesame,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  defp description do
    """
    Basic resource / URL signing for Plug-based Elixir apps.
    """
  end

  defp package do
    [maintainers: ["Matt Weldon"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/sauce-consultants/sesame"}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:joken, "~> 1.5"},
      {:poison, "~> 3.1"},
      {:plug, "~> 1.4"}
    ]
  end
end
