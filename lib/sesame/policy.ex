defmodule Sesame.Policy do
  @doc """
  Determines if the serialized signer is permitted to sign or access the resource.
  """
  @callback is_permitted?(String.t, String.t) :: :ok | :error

end