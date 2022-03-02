defmodule PraguePark.PrakingStatistics.ApiTest do
  use PraguePark.DataCase

  import Mock

  alias PraguePark.Parkings
  alias PraguePark.ParkingStatistics

  describe "fetch_place_occupancy/1" do
    setup do
      resource_params = %{spot_id: "534013", refresh_period: 5}

      {:ok, place} =
        %Parkings.Place{}
        |> Parkings.Place.changeset(resource_params)
        |> PraguePark.Repo.insert()

      {:ok, %{place: place}}
    end

    test "with success request should return decoded body", %{place: place} do
      url = "http://private-b2c96-mojeprahaapi.apiary-mock.com/pr-parkings/#{place.spot_id}"

      body =
        "{\n    \"type\": \"Feature\",\n    \"geometry\": {\n        \"type\": \"Point\",\n        \"coordinates\": [14.350451, 50.05053]\n    },\n    \"properties\": {\n        \"id\": 534013,\n        \"last_updated\": 1502178725000,\n        \"name\": \"Nové Butovice\",\n        \"num_of_taken_places\": 0,\n        \"num_of_total_places\": 57,\n        \"total_num_of_places\": 57,\n        \"pr\": true,\n        \"district\": \"praha-13\",\n        \"address\": \"Seydlerova 2152/1, Stodůlky, 158 00 Praha-Praha 13, Česko\"\n    }\n}"

      decoded_body = Jason.decode!(body)

      with_mock(:hackney, request: fn :get, ^url, _, _, _ -> {:ok, 200, [], body} end) do
        assert {:ok, ^decoded_body} = ParkingStatistics.Api.fetch_place_occupancy(place)
      end
    end

    test "with error request should return error bad request", %{place: place} do
      url = "http://private-b2c96-mojeprahaapi.apiary-mock.com/pr-parkings/#{place.spot_id}"

      with_mock(:hackney, request: fn :get, ^url, _, _, _ -> {:ok, 400, [], ""} end) do
        assert {:error, :bad_request} = ParkingStatistics.Api.fetch_place_occupancy(place)
      end
    end
  end
end
