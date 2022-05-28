defmodule RapydFxExample.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      RapydFxExample.Repo,
      # Start the Telemetry supervisor
      RapydFxExampleWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: RapydFxExample.PubSub},
      # Start the Endpoint (http/https)
      RapydFxExampleWeb.Endpoint
      # Start a worker by calling: RapydFxExample.Worker.start_link(arg)
      # {RapydFxExample.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RapydFxExample.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RapydFxExampleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
