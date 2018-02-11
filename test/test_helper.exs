defmodule Sesame.TestSesameSerializer do
  @moduledoc false

  @behaviour Sesame.Serializer

  def for_token(%{error: :unknown}), do: {:error, "Unknown resource type"}
  def for_token(aud) do 
    {:ok, "User:#{aud[:id]}"}
  end

  def from_token(aud), do: {:ok, aud}
end

defmodule Sesame.TestSesamePolicy do
  @moduledoc false

  @behaviour Sesame.Policy
  
  def is_permitted?(_, "User:1"), do: :ok
  def is_permitted?(_, _), do: :error
end


ExUnit.start()
