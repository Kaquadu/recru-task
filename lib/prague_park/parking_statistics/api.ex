defmodule PraguePark.ParkingStatistics.Api do
  alias PraguePark.Parkings.Place

  def fetch_place_occupancy(%Place{spot_id: spot_id}) do
    url = Enum.join([endpoint_url(), spot_id])

    case :hackney.request(:get, url, headers(), "", [:with_body]) do
      {:ok, 200, _headers, body} ->
        {:ok, Jason.decode!(body)}

      _any_other_error ->
        {:error, :bad_request}
    end
  end

  ###

  defp headers() do
    [
      {"accept", "application/json"}
    ]
  end

  defp endpoint_url() do
    Application.fetch_env!(:prague_park, :endpoint_url)
  end
end
