defmodule Unit.JWTTest do
  use ExUnit.Case
  doctest Sesame

  describe "creating a token" do

    test "can create a valid token" do
      token = Sesame.JWT.create(%{test: "123"})
      assert is_binary(token)
    end

  end

  describe "verifying a token" do

    test "can verify a token" do
      token = Sesame.JWT.create(%{test: "123"})
      verified_token = Sesame.JWT.check(token)
      assert verified_token.claims == %{"test" => "123"}
    end

  end

end
