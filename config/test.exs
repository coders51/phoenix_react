use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phoenix_react, PhoenixReact.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :phoenix_react, PhoenixReact.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "",
  database: "phoenix_react_test",
  hostname: "localhost",
  pool_size: 10,
  pool: Ecto.Adapters.SQL.Sandbox


config :phoenix_react, PhoenixReact.ReactIo,
  script: "node_modules/react-stdio/bin/react-stdio",
  watch_files: [
    Path.join([__DIR__, "../priv/static/js/server.js"])
  ]
