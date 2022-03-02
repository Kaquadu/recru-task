defmodule PraguePark.Parkings.Place do
  use PraguePark.Schema

  alias PraguePark.ParkingStatistics.Occupancy

  @required_fields ~w(spot_id refresh_period)a

  schema "places" do
    field :spot_id, :string
    field :refresh_period, :integer, default: 5

    has_one :occupancy, Occupancy

    timestamps()
  end

  def changeset(place, attrs \\ %{}) do
    place
    |> cast(attrs, @required_fields)
    |> validate_inclusion(:refresh_period, 1..10)
    |> unique_constraint(:spot_id)
    |> validate_required(@required_fields)
  end
end
