defmodule Agala.Provider.Viber.Controllers.Verification do
  alias Plug.Conn

  alias Agala.Provider.Viber.Controllers.View

  def handle(conn) do
    conn
    |> Conn.fetch_query_params()
    |> verify_request()
  end

  defp verify_request(
         %{
           private: %{
             body: %{"event" => "webhook"}
           }
         } = conn
       ) do
    conn
    |> Conn.put_resp_content_type("application/json")
    |> Conn.send_resp(:ok, "")
  end

  defp verify_request(conn) do
    case conn.private.agala_bot_config[:chain] do
      nil ->
        raise ArgumentError, "chain is not specified"

      chain ->
        chain.call(
          %Agala.Conn{
            request: conn.private.body,
            request_bot_params: conn.private.agala_bot_config
          },
          []
        )
        |> resolve_response(conn)
    end
  end

  def resolve_response(%Agala.Conn{response: {:error, reason}}, conn) do
    conn
    |> View.render(400, %{errors: reason})
  end

  def resolve_response(%Agala.Conn{response: nil}, conn) do
    conn
    |> View.render(:ok)
  end
end
