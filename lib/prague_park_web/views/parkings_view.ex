defmodule PragueParkWeb.ParkingsView do
  use PragueParkWeb, :view

  def render("refresh.json", %{place: place}) do
    %{
      place:
        render_one(
          place,
          __MODULE__,
          "place.json",
          as: :place
        )
    }
  end

  def render("place.json", %{place: place}) do
    %{
      spot_id: place.spot_id,
      refresh_period: place.refresh_period
    }
  end
end
