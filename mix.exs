defmodule PhoenixReact.Mixfile do
  use Mix.Project

  def project do
    [app: :phoenix_react,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {PhoenixReact, []},
      applications: [
        :phoenix,
        :phoenix_pubsub,
        :phoenix_html,
        :cowboy,
        :sentry,
        :logger,
        :gettext,
        :phoenix_ecto,
        :postgrex,
        :oauth2,
        :std_json_io,
        :httpoison,
        :secure_random,
        :logger_file_backend,
        :edeliver,
        :ueberauth,
        :guardian,
        :guardian_db
        ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2.1"},
     {:phoenix_pubsub, "~> 1.0"},
     {:sentry, "~> 3.0.0"},
     {:secure_random, "~> 0.5"},
     {:phoenix_ecto, "~> 3.0"},
     {:postgrex, ">= 0.0.0"},
     {:ex_machina, "~> 1.0", only: :test},
     {:phoenix_html, "~> 2.6"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.11"},
     {:oauth2, "~> 0.9"},
     {:cowboy, "~> 1.0"},
     {:distillery, "~> 1.0"},
     {:faker, "~> 0.7", only: :test},
     {:httpoison, "~> 0.11.0"},
     {:std_json_io, git: "git@github.com:coders51/std_json_io.git"},
     {:edeliver, "~> 1.4.2"},
     {:logger_file_backend, "~> 0.0.9"},
     {:ueberauth, "~> 0.4"},
     {:guardian, "~> 0.14"},
     {:guardian_db, "~> 0.8.0"},
   ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
