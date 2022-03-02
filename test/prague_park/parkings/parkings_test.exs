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
               Parkings.update_place_refresh_period(Ecto.UUID.generate(), %{"refresh_period" => 1})
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
                 "spot_id" => Ecto.UUID.generate()
               })

      assert refresh_period == update_period
      assert spot_id == returned_spot_id
    end
  end

  describe "create_place/1" do
    test "with valid data should create place" do
      params = %{
        spot_id: "654321",
        refresh_period: 8
      }

      assert {:ok, place} = Parkings.create_place(params)
      assert place.refresh_period == 8
      assert place.spot_id == "654321"
    end

    test "without refresh period should create place with default refresh period" do
      params = %{
        spot_id: "654321"
      }

      assert {:ok, place} = Parkings.create_place(params)
      assert place.refresh_period == 5
      assert place.spot_id == "654321"
    end

    test "with valid data but existing spot should return error on spot id" do
      params = %{
        spot_id: "654321",
        refresh_period: 8
      }

      {:ok, _place} = Parkings.create_place(params)

      assert {:error, %{valid?: false} = changeset} = Parkings.create_place(params)
      assert %{spot_id: ["has already been taken"]} = errors_on(changeset)
    end

    test "with ivalid data should return error tuple with invalid changeset" do
      params = %{
        spot_id: "654321",
        refresh_period: 11
      }

      assert {:error, %{valid?: false} = changeset} = Parkings.create_place(params)
      assert %{refresh_period: ["is invalid"]} = errors_on(changeset)
    end
  end

  describe "get_place_by_spot_id/1" do
    setup do
      resource_params = %{spot_id: "534013", refresh_period: 5}

      {:ok, place} =
        %Parkings.Place{}
        |> Parkings.Place.changeset(resource_params)
        |> PraguePark.Repo.insert()

      {:ok, %{place: place}}
    end

    test "with valid spot id should return :ok with place", %{place: place} do
      assert {:ok, result} = Parkings.get_place_by_spot_id(place.spot_id)
      assert result.id == place.id
    end

    test "with non existing spot id should not found error" do
      assert {:error, :not_found} = Parkings.get_place_by_spot_id(Ecto.UUID.generate())
    end
  end
end
