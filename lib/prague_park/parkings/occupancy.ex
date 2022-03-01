defmodule PraguePark.Parkings.Occupancy do
  use PraguePark.Schema

  @required_fields ~w(spot_id free_places taken_places)a

  schema "occupancies" do
    field :free_places, :integer
    field :taken_places, :integer

    belongs_to :place, PraguePark.Parkings.Place

    timestamps()
  end

  def changeset(place, attrs \\ %{}) do
    place
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
