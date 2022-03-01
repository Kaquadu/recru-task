import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :prague_park, PraguePark.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "prague_park_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :prague_park, PragueParkWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "yCMFmPRw47KxEdkVGtM3jEQIJIlB6ivYfrzr9iDDkg9AdX0YKxgs83u7kpypp2aH",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
