defmodule PragueParkWeb.Router do
  use PragueParkWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PragueParkWeb do
    pipe_through :api

    post "/parkings/:id", ParkingsController, :update_refresh_period

    get "/parkings/:id", ParkingStatisticsController, :get_occupancy
  end
end
