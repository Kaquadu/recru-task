# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PraguePark.Repo.insert!(%PraguePark.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias PraguePark.Parkings.Place
alias PraguePark.ParkingStatistics.Occupancy

resources = [
  %{spot_id: "534013", refresh_period: 5}
]

for resource <- resources do
  {:ok, place} =
    %Place{}
    |> Place.changeset(resource)
    |> PraguePark.Repo.insert()

  {:ok, _occupancy} =
    %Occupancy{}
    |> Occupancy.changeset(%{place_id: place.id})
    |> PraguePark.Repo.insert()
end
