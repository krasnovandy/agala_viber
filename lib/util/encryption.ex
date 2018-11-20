defmodule Agala.Provider.Viber.Util.Encryption do
  @moduledoc false

  @doc """
  Validate sha256 signature for given binary
  """
  @spec validate_sha256(secret :: String.t(), body :: binary(), signature :: String.t()) ::
          :ok | {:error, Map.t()}
  def validate_sha256(secret, body, signature) do
    case signature == calculate_sha256(secret, body) do
      true -> :ok
      false -> {:error, %{signature: "invalid"}}
    end
  end

  @doc """
  Calculate sha256
  """
  @spec calculate_sha256(secret :: String.t(), body :: binary()) :: String.t()
  defp calculate_sha256(secret, body) do
    calculate_sha(:sha256, secret, body)
  end

  defp calculate_sha1(secret, body) do
    calculate_sha(:sha, secret, body)
  end

  defp calculate_sha(alg, secret, body) do
    alg
    |> :crypto.hmac("#{secret}", "#{body}")
    |> Base.encode16()
    |> String.downcase()
  end
end

# def _calculate_message_signature(self, message):
#   return hmac.new(
#     bytes(self._bot_configuration.auth_token.encode('ascii')),
#     msg=message,
#     digestmod=hashlib.sha256)\
#     .hexdigest()
