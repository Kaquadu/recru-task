defmodule PraguePark.Parkings do
  import Ecto.Query

  alias PraguePark.Parkings.Place

  @repo PraguePark.Repo

  def update_place_refresh_period(spot_id, params) do
    with {:ok, place} <- get_place_by_spot_id(spot_id),
         %{valid?: true} = changeset <-
           Place.changeset(place, %{refresh_period: params["refresh_period"]}) do
      @repo.update(changeset)
    else
      %Ecto.Changeset{} = changeset ->
        {:error, changeset}

      error ->
        error
    end
  end

  ###

  defp get_place_by_spot_id(spot_id) do
    Place
    |> where([p], p.spot_id == ^spot_id)
    |> @repo.fetch()
  end
end
