defmodule PragueParkWeb.ParkingStatisticsControllerTest do
  use PragueParkWeb.ConnCase

  alias PraguePark.Parkings
  alias PraguePark.ParkingStatistics.Occupancy

  describe "get_occupancy/2" do
    test "with existing place and occupancy it should return occupancy", %{conn: conn} do
      spot_id = "534013"
      resource_params = %{spot_id: spot_id, refresh_period: 5}

      {:ok, place} =
        %Parkings.Place{}
        |> Parkings.Place.changeset(resource_params)
        |> PraguePark.Repo.insert()

      taken_places = 10
      total_places = 57

      %Occupancy{}
      |> Occupancy.changeset(%{
        place_id: place.id,
        taken_places: taken_places,
        total_places: total_places
      })
      |> Repo.insert!()

      assert %{"occupancy" => %{"total_places" => ^total_places, "taken_places" => ^taken_places}} =
               conn
               |> get(parking_statistics_path(conn, :get_occupancy, spot_id))
               |> json_response(200)
    end

    test "with existing place but no occupancy it should return 404 error", %{conn: conn} do
      spot_id = "534013"
      resource_params = %{spot_id: spot_id, refresh_period: 5}

      {:ok, _place} =
        %Parkings.Place{}
        |> Parkings.Place.changeset(resource_params)
        |> PraguePark.Repo.insert()

      assert %{} =
               conn
               |> get(parking_statistics_path(conn, :get_occupancy, spot_id))
               |> json_response(404)
    end

    test "with non existing place it should return 404 error", %{conn: conn} do
      assert %{} =
               conn
               |> get(parking_statistics_path(conn, :get_occupancy, Ecto.UUID.generate()))
               |> json_response(404)
    end
  end
end
