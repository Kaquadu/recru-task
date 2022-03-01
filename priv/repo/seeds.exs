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

resources = [
  %{spot_id: "534013", refresh_period: 5}
]

for resource <- resources do
  %Place{}
  |> Place.changeset(resource)
  |> PraguePark.Repo.insert()
end
