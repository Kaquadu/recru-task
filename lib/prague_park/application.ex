defmodule PraguePark.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      PraguePark.Repo,
      # Start the Telemetry supervisor
      PragueParkWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: PraguePark.PubSub},
      # Start the Endpoint (http/https)
      PragueParkWeb.Endpoint,
      # Start a worker by calling: PraguePark.Worker.start_link(arg)
      # {PraguePark.Worker, arg}
      # Quantum scheduler
      PraguePark.Scheduler
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PraguePark.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PragueParkWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
