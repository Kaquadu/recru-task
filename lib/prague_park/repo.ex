defmodule PraguePark.Repo do
  use Ecto.Repo,
    otp_app: :prague_park,
    adapter: Ecto.Adapters.Postgres
end
