use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :phoenix_codedeploy, PhoenixCodedeploy.Endpoint,
  secret_key_base: "uNt9GxV6880nrptnOS6O1ra6leo6TaJUpKunXmnskwbMyfHqMC8Y+O1o04IlwDfR"

# Configure your database
config :phoenix_codedeploy, PhoenixCodedeploy.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "phoenix_codedeploy_prod",
  size: 20 # The amount of database connections in the pool
