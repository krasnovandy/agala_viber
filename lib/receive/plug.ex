defmodule Agala.Provider.Viber.Plug do
  @moduledoc """
  This module can be used as Plug for
  """

  ############################################################################
  # Router for messenger webhooks                                            #
  ############################################################################

  use Plug.Router
  alias Agala.Provider.Viber.Plugs.{RawBodyExtractor, Validator}
  alias Agala.Provider.Viber.Controllers.{Verification, View, Callback}
  alias Agala.Provider.Viber.Chains.JsonDecoder
  # alias MessengerBot.Web.Controller.Messenger
  # alias MessengerBot.Web.Plug.{MaxBodyLength, AppAuthentication, Transaction, EventBus}

  plug(RawBodyExtractor)
  # plug(Validator)
  plug(JsonDecoder)
  plug(:match)
  plug(:dispatch)

  ############################################################################
  # All Viber Messenger webhook events will hit to this endpoint
  # POST /:app_id
  ############################################################################
  # post(_, do: Callback.handle(conn))

  # POST / - Webhook verification

  # POST / - Webhook verification
  post(_, do: Verification.handle(conn))

  # 404 response to all other routes
  match(_, do: View.render(conn, :not_found, %{page: "Not found!"}))
end
