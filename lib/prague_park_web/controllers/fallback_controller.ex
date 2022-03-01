defmodule PragueParkWeb.FallbackController do
  use Phoenix.Controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> json(%{})
  end

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{error: format_changeset_errors(changeset)})
  end

  defp format_changeset_errors(%{errors: errors}) do
    errors
    |> Enum.map(fn {field, {message, opts}} ->
      # replaces keys in error messages with values
      message =
        Enum.reduce(opts, message, fn
          {key, min..max}, acc ->
            String.replace(acc, "%{#{key}}", "#{min}..#{max}")

          {key, value}, acc ->
            String.replace(acc, "%{#{key}}", to_string(value))
        end)

      {field, message}
    end)
    |> Enum.into(%{})
  end
end
