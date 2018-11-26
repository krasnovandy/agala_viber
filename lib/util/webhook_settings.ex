defmodule Agala.Provider.Viber.Util.WebhookSetting do
  @moduledoc """
    Viber webhooks managing
  """

  @viber_url "https://chatapi.viber.com/pa/set_webhook"
  @viber_auth_header_name "X-Viber-Auth-Token"

  def set(url: url, events: events, token: token) do
    HTTPoison.request!(:post, @viber_url, Jason.encode!(body(url, events)), headers(token))
    |> fetch_body
    |> operation_status(:set)
  end

  def remove(token) do
    HTTPoison.request!(:post, @viber_url, Jason.encode!(body("")), headers(token))
    |> fetch_body
    |> operation_status(:unset)
  end

  defp body(url, events \\ []) do
    %{
      "event_types" => events,
      "send_name" => true,
      "url" => url
    }
  end

  defp headers(app_secret) do
    [
      {"Content-Type", "application/json"},
      {@viber_auth_header_name, app_secret}
    ]
  end

  defp fetch_body(%HTTPoison.Response{body: body}) do
    body |> Jason.decode!()
  end

  defp operation_status(%{"status" => 0}, :set) do
    {:ok, :webhook_set}
  end

  defp operation_status(%{"status" => 0}, :unset) do
    {:ok, :webhook_removed}
  end

  defp operation_status(%{"status_message" => status_message}, _) do
    {:error, status_message}
  end
end
