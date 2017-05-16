# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :phoenix_react,
  ecto_repos: [PhoenixReact.Repo]

# Configures the endpoint
config :phoenix_react, PhoenixReact.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "WwqUsGtm8CTiin3mOcwmuMasdasdqwdasdyn3Tt8xCVA/1Uv3ah0ry8+GVnFnhTS5/xX54TrXfcj",
  render_errors: [view: PhoenixReact.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PhoenixReact.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  permissions: %{
    default: [
      :read,
      :write,
    ]
  }

config :guardian, Guardian,
           hooks: GuardianDb

config :guardian_db, GuardianDb,
       repo: PhoenixReact.Repo,
           sweep_interval: 120

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
