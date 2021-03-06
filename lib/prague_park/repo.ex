defmodule PraguePark.Repo do
  use Ecto.Repo,
    otp_app: :prague_park,
    adapter: Ecto.Adapters.Postgres

  def fetch(query) do
    case __MODULE__.one(query) do
      nil -> {:error, :not_found}
      result -> {:ok, result}
    end
  end
end
