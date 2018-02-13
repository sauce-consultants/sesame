defmodule Sesame.JWT do

  import Joken

  def create(claims) do
    claims
    |> token
    |> with_signer(hs256(Sesame.Config.secret_key))
    |> sign
    |> get_compact
  end

  def check(nil), do: :error
  def check(""), do: :error
  def check(signed_token) do
    signed_token
    |> token
    |> with_signer(hs256(Sesame.Config.secret_key))
    |> verify
  end
  
end