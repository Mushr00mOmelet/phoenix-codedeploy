use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :phoenix_codedeploy, PhoenixCodedeploy.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  cache_static_lookup: false,
  watchers: []

# Watch static and templates for browser reloading.
config :phoenix_codedeploy, PhoenixCodedeploy.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Override recipients so we don't spam actual accounts
# with test emails
config :sog_api, :email,
  contact_to: "fake@example.com"

# Use test gateway
config :phoenix_codedeploy, :stripe,
 token: "sk_test_QwrSPonmUQuMLs7KvLTgfhY"

# Configure your database
config :phoenix_codedeploy, PhoenixCodedeploy.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "phoenix_codedeploy_dev"
