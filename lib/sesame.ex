defmodule Sesame do
  @moduledoc """
  Documentation for Sesame.
  """

  @doc """
  Sign a resource.
  """
  def sign(resource, signer) do
    serializer = Sesame.Config.serializer
    policy = Sesame.Config.policy

    case serializer.for_token(signer) do
      {:ok, serialized_signer}  ->

        case policy.is_permitted?(resource, serialized_signer) do
          :ok ->
            claims = %{resource: resource, signer: serialized_signer}
            signature = Sesame.JWT.create(claims)
            create_response(resource, signature)
          :error ->
            :error
        end

      {:error, _} ->
        :error
    end
  end

  def create_response(resource, signature) do
    %{
      resource: resource,
      signature: signature,
      signed_resource: create_signed_resource(resource, signature)
    }
  end

  defp create_signed_resource(resource, signature) do
    if String.contains?(resource, "?") do
      "#{resource}&signature=#{signature}"
    else
      "#{resource}?signature=#{signature}"
    end
  end

  @doc """
  Verifies a resource can be accessed based on the signature.
  """
  def verify(signature, resource) do
    policy = Sesame.Config.policy

    case Sesame.JWT.check(signature) do
      :error -> :error
      unpacked_jwt ->
        unpacked_resource = unpacked_jwt.claims["resource"]
        unpacked_signer   = unpacked_jwt.claims["signer"]
    
        if strip_scheme(unpacked_resource) == strip_scheme(resource) do
          policy.is_permitted?(resource, unpacked_signer)
        else
          :error
        end
    end
  end

  def strip_scheme("http://" <> resource), do: resource
  def strip_scheme("https://" <> resource), do: resource
  def strip_scheme("ftp://" <> resource), do: resource
  def strip_scheme(resource), do: resource

  @doc """
  Deserialises the signer from the signature on the connection
  """
  def current_signer(conn) do
    serializer = Sesame.Config.serializer
    signature = conn |> find_signature
    unpacked_jwt = Sesame.JWT.check(signature)

    unpacked_resource = unpacked_jwt.claims["resource"]
    unpacked_signer   = unpacked_jwt.claims["signer"]

    serializer.from_token(unpacked_signer)
  end

  defp find_signature(conn) do
    conn.query_string
    |> String.split("&")
    |> Enum.map(fn(part) ->
      case part |> String.split("=") do
        ["signature", signature] -> signature
        _ -> nil
      end
    end)
    |> Enum.reject(fn(x) -> x == nil end)
    |> List.first
  end

end
