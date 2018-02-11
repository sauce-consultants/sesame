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
    
    unpacked_jwt = Sesame.JWT.check(signature)

    unpacked_resource = unpacked_jwt.claims["resource"]
    unpacked_signer   = unpacked_jwt.claims["signer"]

    if unpacked_resource == resource do
      policy.is_permitted?(resource, unpacked_signer)
    else
      :error
    end
  end
end
