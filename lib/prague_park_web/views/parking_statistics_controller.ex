defmodule PragueParkWeb.ParkingStatisticsView do
  use PragueParkWeb, :view

  def render("last_occupancy.json", %{occupancy: occupancy}) do
    %{
      occupancy:
        render_one(
          occupancy,
          __MODULE__,
          "occupancy.json",
          as: :occupancy
        )
    }
  end

  def render("occupancy.json", %{occupancy: occupancy}) do
    %{
      total_places: occupancy.total_places,
      taken_places: occupancy.taken_places
    }
  end
end
