defmodule PragueParkWeb.Router do
  use PragueParkWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PragueParkWeb do
    pipe_through :api

    post "/crawlers/:id", ParkingsController, :update_refresh_period

    get "/parkings/:id", ParkingStatisticsController, :get_occupancy
  end
end
