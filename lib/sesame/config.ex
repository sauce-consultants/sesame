defmodule Sesame.Config do

  def secret_key do
    get_config(:secret_key)
  end

  def serializer do
    get_config(:serializer)
  end

  def policy do
    get_config(:policy)
  end

  defp get_config(key) do
    config = :sesame |> Application.get_env(Sesame)
    config[key]
  end
  
end