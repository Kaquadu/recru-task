defmodule PragueParkWeb.ParkingsControllerTest do
  use PragueParkWeb.ConnCase

  alias PraguePark.Parkings

  describe "update_refresh_period/2" do
    setup do
      resource_params = %{spot_id: "534013", refresh_period: 5}

      {:ok, place} =
        %Parkings.Place{}
        |> Parkings.Place.changeset(resource_params)
        |> PraguePark.Repo.insert()

      {:ok, %{place: place}}
    end

    test "with spot id and refresh period in params returns updated place", %{
      conn: conn,
      place: %{spot_id: spot_id}
    } do
      update_period = 10

      assert %{
               "refresh_period" => ^update_period,
               "spot_id" => ^spot_id
             } =
               conn
               |> post(parkings_path(conn, :update_refresh_period, spot_id), %{
                 "refresh_period" => update_period
               })
               |> json_response(200)
    end

    test "with invalid spot id returns 404", %{conn: conn} do
      assert %{} =
               conn
               |> post(parkings_path(conn, :update_refresh_period, "111111"), %{
                 "refresh_period" => 5
               })
               |> json_response(404)
    end

    test "with invalid refresh period returns 422 and errors", %{
      conn: conn,
      place: %{spot_id: spot_id}
    } do
      assert %{"error" => %{"refresh_period" => "is invalid"}} =
               conn
               |> post(parkings_path(conn, :update_refresh_period, spot_id), %{
                 "refresh_period" => 11
               })
               |> json_response(422)
    end

    test "with no refresh period returns 422 and errors", %{
      conn: conn,
      place: %{spot_id: spot_id}
    } do
      assert %{"error" => %{"refresh_period" => "can't be blank"}} =
               conn
               |> post(parkings_path(conn, :update_refresh_period, spot_id), %{})
               |> json_response(422)
    end

    test "with other params updates only refresh period", %{
      conn: conn,
      place: %{spot_id: spot_id}
    } do
      update_period = 10

      assert %{
               "refresh_period" => ^update_period,
               "spot_id" => ^spot_id
             } =
               conn
               |> post(parkings_path(conn, :update_refresh_period, spot_id), %{
                 "refresh_period" => update_period,
                 "spot_id" => "11111"
               })
               |> json_response(200)
    end
  end
end
