defmodule PraguePark.Repo.Migrations.CreateBaseModels do
  use Ecto.Migration

  def change do
    create table("places", primary_key: false) do
      add :id, :uuid, primary_key: true
      add :spot_id, :string, null: false
      add :refresh_period, :integer, null: false

      timestamps()
    end

    create unique_index("places", :spot_id)

    create table("occupancies", primary_key: false) do
      add :id, :uuid, primary_key: true
      add :total_places, :integer
      add :taken_places, :integer

      add :place_id, references("places", type: :uuid)

      timestamps()
    end

    create unique_index("occupancies", :place_id)
  end
end
