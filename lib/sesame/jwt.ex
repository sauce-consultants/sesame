defmodule Sesame.JWT do

  import Joken

  def create(claims) do
    {_, token, _} = Joken.generate_and_sign(%{}, claims, Joken.Signer.create("HS256", Sesame.Config.secret_key))

    token
  end

  def check(nil), do: :error
  def check(""), do: :error
  def check(signed_token) do
    {_, claims } = signed_token
      |> verify(Joken.Signer.create("HS256", Sesame.Config.secret_key))

    %{ claims: claims }
  end

end
