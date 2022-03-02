defmodule PragueParkWeb.ParkingStatisticsController do
  use Phoenix.Controller

  alias PraguePark.ParkingStatistics

  action_fallback PragueParkWeb.FallbackController

  def get_occupancy(conn, %{"id" => spot_id}) do
    case ParkingStatistics.get_last_place_occupancy(spot_id) do
      {:ok, occupancy} ->
        conn
        |> put_status(:ok)
        |> render("last_occupancy.json", occupancy: occupancy)

      error ->
        error
    end
  end
end
