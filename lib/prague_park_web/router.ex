defmodule PragueParkWeb.Router do
  use PragueParkWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PragueParkWeb do
    pipe_through :api
  end
end
