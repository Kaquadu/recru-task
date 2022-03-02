defmodule PraguePark.PrakingStatisticsTest do
  use PraguePark.DataCase

  import Mock

  alias PraguePark.Parkings
  alias PraguePark.ParkingStatistics
  alias PraguePark.ParkingStatistics.Occupancy

  describe "upsert_place_occupancy/1" do
    test "with existing place, but no occupancies yet it should create occupancy" do
      spot_id = "534013"
      resource_params = %{spot_id: spot_id, refresh_period: 5}

      {:ok, _place} =
        %Parkings.Place{}
        |> Parkings.Place.changeset(resource_params)
        |> PraguePark.Repo.insert()

      url = "http://private-b2c96-mojeprahaapi.apiary-mock.com/pr-parkings/#{spot_id}"

      body =
        "{\n    \"type\": \"Feature\",\n    \"geometry\": {\n        \"type\": \"Point\",\n        \"coordinates\": [14.350451, 50.05053]\n    },\n    \"properties\": {\n        \"id\": 534013,\n        \"last_updated\": 1502178725000,\n        \"name\": \"Nové Butovice\",\n        \"num_of_taken_places\": 0,\n        \"num_of_total_places\": 57,\n        \"total_num_of_places\": 57,\n        \"pr\": true,\n        \"district\": \"praha-13\",\n        \"address\": \"Seydlerova 2152/1, Stodůlky, 158 00 Praha-Praha 13, Česko\"\n    }\n}"

      with_mock(:hackney, request: fn :get, ^url, _, _, _ -> {:ok, 200, [], body} end) do
        assert {:ok, %Occupancy{} = occupancy} = ParkingStatistics.upsert_place_occupancy(spot_id)

        refute is_nil(occupancy.taken_places)
        refute is_nil(occupancy.total_places)
      end
    end

    test "with not existing place it should create place and occupancy" do
      spot_id = "534013"

      url = "http://private-b2c96-mojeprahaapi.apiary-mock.com/pr-parkings/#{spot_id}"

      body =
        "{\n    \"type\": \"Feature\",\n    \"geometry\": {\n        \"type\": \"Point\",\n        \"coordinates\": [14.350451, 50.05053]\n    },\n    \"properties\": {\n        \"id\": 534013,\n        \"last_updated\": 1502178725000,\n        \"name\": \"Nové Butovice\",\n        \"num_of_taken_places\": 0,\n        \"num_of_total_places\": 57,\n        \"total_num_of_places\": 57,\n        \"pr\": true,\n        \"district\": \"praha-13\",\n        \"address\": \"Seydlerova 2152/1, Stodůlky, 158 00 Praha-Praha 13, Česko\"\n    }\n}"

      with_mock(:hackney, request: fn :get, ^url, _, _, _ -> {:ok, 200, [], body} end) do
        assert {:ok, %Occupancy{} = occupancy} = ParkingStatistics.upsert_place_occupancy(spot_id)

        assert Repo.get_by(Parkings.Place, spot_id: spot_id)

        refute is_nil(occupancy.taken_places)
        refute is_nil(occupancy.total_places)
      end
    end

    test "with already existing occupancy it should update the existing one" do
      spot_id = "534013"
      resource_params = %{spot_id: spot_id, refresh_period: 5}

      {:ok, place} =
        %Parkings.Place{}
        |> Parkings.Place.changeset(resource_params)
        |> PraguePark.Repo.insert()

      url = "http://private-b2c96-mojeprahaapi.apiary-mock.com/pr-parkings/#{spot_id}"

      body =
        "{\n    \"type\": \"Feature\",\n    \"geometry\": {\n        \"type\": \"Point\",\n        \"coordinates\": [14.350451, 50.05053]\n    },\n    \"properties\": {\n        \"id\": 534013,\n        \"last_updated\": 1502178725000,\n        \"name\": \"Nové Butovice\",\n        \"num_of_taken_places\": 0,\n        \"num_of_total_places\": 57,\n        \"total_num_of_places\": 57,\n        \"pr\": true,\n        \"district\": \"praha-13\",\n        \"address\": \"Seydlerova 2152/1, Stodůlky, 158 00 Praha-Praha 13, Česko\"\n    }\n}"

      with_mock(:hackney, request: fn :get, ^url, _, _, _ -> {:ok, 200, [], body} end) do
        %Occupancy{}
        |> Occupancy.changeset(%{place_id: place.id, taken_places: 10, total_places: 57})
        |> Repo.insert!()

        assert {:ok, %Occupancy{} = occupancy} = ParkingStatistics.upsert_place_occupancy(spot_id)

        assert occupancy.taken_places == 0
        assert occupancy.total_places == 57
      end
    end
  end

  describe "get_last_place_occupancy/1" do
    test "with existing place and occupancy should return its occupancy" do
      spot_id = "534013"
      resource_params = %{spot_id: spot_id, refresh_period: 5}

      {:ok, place} =
        %Parkings.Place{}
        |> Parkings.Place.changeset(resource_params)
        |> PraguePark.Repo.insert()

      %Occupancy{}
      |> Occupancy.changeset(%{place_id: place.id, taken_places: 10, total_places: 57})
      |> Repo.insert!()

      assert {:ok, occupancy} = ParkingStatistics.get_last_place_occupancy(spot_id)
      assert occupancy.place_id == place.id
    end

    test "with existing place but without occupancy should return error not found" do
      spot_id = "534013"
      resource_params = %{spot_id: spot_id, refresh_period: 5}

      {:ok, _place} =
        %Parkings.Place{}
        |> Parkings.Place.changeset(resource_params)
        |> PraguePark.Repo.insert()

      assert {:error, :not_found} = ParkingStatistics.get_last_place_occupancy(spot_id)
    end

    test "with non existing place should return error not found" do
      assert {:error, :not_found} =
               ParkingStatistics.get_last_place_occupancy(Ecto.UUID.generate())
    end
  end
end
