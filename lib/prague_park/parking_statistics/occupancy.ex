defmodule PraguePark.ParkingStatistics.Occupancy do
  use PraguePark.Schema

  @required_fields ~w(place_id)a
  @optional_fields ~w(taken_places total_places)a

  schema "occupancies" do
    field :taken_places, :integer
    field :total_places, :integer

    belongs_to :place, PraguePark.Parkings.Place

    timestamps()
  end

  def changeset(place, attrs \\ %{}) do
    place
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> unique_constraint(:place_id)
    |> validate_required(@required_fields)
  end
end
