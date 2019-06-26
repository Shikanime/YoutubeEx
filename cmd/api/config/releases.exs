import Config

repo_password =
  System.get_env("POSTGRES_PASSWORD") ||
    raise """
    Postgres password must be set
    """

repo_hostname =
  System.get_env("POSTGRES_HOST") ||
    "localhost"

phoenix_secret_base =
  System.get_env("PHOENIX_SECRET") ||
    raise """
    Phoenix secret must set
    """

host = System.get_env("HOST") || "localhost"

port = System.get_env("PORT") || 80

# Configure your database
config :api, Api.Repo,
  password: repo_password,
  hostname: repo_hostname

# Configures the endpoint
config :api_web, Api.Web.Endpoint,
  url: [host: host],
  secret_key_base: phoenix_secret_base,
  http: [port: port]
