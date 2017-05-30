# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :liquid_dots, LiquidDots.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "K84AFd9Qy0QRl03NGwI7OXciUG//7ENB0T8Qr4AsjcdY067NeN9o6zEbtO11+9fD",
  render_errors: [view: LiquidDots.ErrorView, accepts: ~w(html json)],
  pubsub: [name: LiquidDots.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Uncomment this to broadcast
#config :app, App.Endpoint,
  #http: [ip: {0, 0, 0, 0}, port: 4000]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
