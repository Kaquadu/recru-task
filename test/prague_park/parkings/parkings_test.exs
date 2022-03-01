defmodule PraguePark.PrakingsTest do
  use PraguePark.DataCase

  alias PraguePark.Parkings

  describe "update_place_refresh_period/2" do
    setup do
      resource_params = %{spot_id: "534013", refresh_period: 5}

      {:ok, place} =
        %Parkings.Place{}
        |> Parkings.Place.changeset(resource_params)
        |> PraguePark.Repo.insert()

      {:ok, %{place: place}}
    end

    test "with spot id and valid refresh period should update given place", %{
      place: %{spot_id: spot_id}
    } do
      update_period = 10

      assert {:ok, %{refresh_period: refresh_period}} =
               Parkings.update_place_refresh_period(spot_id, %{"refresh_period" => update_period})

      assert refresh_period == update_period
    end

    test "with invalid spot id should return error not found" do
      assert {:error, :not_found} =
               Parkings.update_place_refresh_period("11111", %{"refresh_period" => 1})
    end

    test "with valid spot id but invalid refresh period should return error with changeset", %{
      place: %{spot_id: spot_id}
    } do
      assert {:error, changeset} =
               Parkings.update_place_refresh_period(spot_id, %{"refresh_period" => 11})

      refute changeset.valid?
      assert %{refresh_period: ["is invalid"]} = errors_on(changeset)
    end

    test "shouldn't update anything else than refresh period", %{place: %{spot_id: spot_id}} do
      update_period = 10

      assert {:ok, %{refresh_period: refresh_period, spot_id: returned_spot_id}} =
               Parkings.update_place_refresh_period(spot_id, %{
                 "refresh_period" => update_period,
                 "spot_id" => "111111"
               })

      assert refresh_period == update_period
      assert spot_id == returned_spot_id
    end
  end
end
