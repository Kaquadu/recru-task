defmodule PraguePark.ParkingStatistics do
  import Ecto.Query

  alias PraguePark.Parkings
  alias PraguePark.ParkingStatistics.{Api, Occupancy}

  @repo PraguePark.Repo

  def get_last_place_occupancy(spot_id) do
    Occupancy
    |> join(:inner, [o], place in assoc(o, :place), on: place.spot_id == ^spot_id)
    |> @repo.fetch()
  end

  def upsert_place_occupancy(spot_id) do
    with {:ok, %{id: place_id} = place} <- Parkings.get_place_by_spot_id(spot_id),
         {:ok, %{"properties" => properties}} <- Api.fetch_place_occupancy(place) do
      params = %{
        place_id: place_id,
        taken_places: properties["num_of_taken_places"],
        total_places: properties["total_num_of_places"]
      }

      %Occupancy{}
      |> Occupancy.changeset(params)
      |> @repo.insert(
        on_conflict: [
          set: [
            taken_places: properties["num_of_taken_places"],
            total_places: properties["total_num_of_places"]
          ]
        ],
        conflict_target: :place_id
      )
    else
      {:error, :not_found} ->
        {:ok, %{spot_id: spot_id} = _place} = Parkings.create_place(%{spot_id: spot_id})
        upsert_place_occupancy(spot_id)

      {:error, :bad_request} ->
        {:error, :bad_request}
    end
  end
end
