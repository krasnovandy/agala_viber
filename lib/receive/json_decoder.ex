defmodule Agala.Provider.Viber.Chains.JsonDecoder do
  @behaviour Agala.Chain

  def init(args), do: args

  def call(%Agala.Conn{request: request} = conn, _opts) when is_binary(request) do
    conn
    |> Map.put(:request, Jason.decode!(request))
    |> IO.inspect(label: "+++++++++JsonDecoder")
  end

  def call(%Plug.Conn{private: %{body: body} = private} = conn, _opts) do
    conn
    |> Map.put(:private, Map.put(private, :body, Jason.decode!(body)))
  end

  def call(conn, opts), do: conn
end
