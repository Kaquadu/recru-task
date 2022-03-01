defmodule PragueParkWeb.ParkingsController do
  use Phoenix.Controller

  alias PraguePark.Parkings

  action_fallback PragueParkWeb.FallbackController

  def update_refresh_period(conn, %{"id" => spot_id} = params) do
    case Parkings.update_place_refresh_period(spot_id, params) do
      {:ok, place} ->
        conn
        |> put_status(:ok)
        |> render("place.json", place: place)

      error ->
        error
    end
  end
end
