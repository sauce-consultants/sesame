defmodule Sesame.Serializer do
  
  @doc """
  Serializes the object into the token. Suggestion: \"User:2\"
  """
  @callback for_token(object :: term) :: {:ok, String.t} | {:error, String.t}

  @doc """
  De-serializes the object from a token
  """
  @callback from_token(subject :: String.t) :: {:ok, object :: term} | {:error, String.t}
  
end