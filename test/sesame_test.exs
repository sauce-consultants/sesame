defmodule SesameTest do
  use ExUnit.Case
  doctest Sesame

  describe "signing a resource" do

    test "will return a map if the user is permitted to sign the resource" do

      result = Sesame.sign("http://wearesauce.io", %{name: "Matt Weldon", id: 1})

      assert result[:signature]
      assert result[:resource]
      assert result[:signed_resource]
    end

    test "will return an :error atom if the user is not permitted to sign the resource" do
      result = Sesame.sign("http://wearesauce.io", %{name: "John Polling", id: 2})

      assert result == :error
    end

    test "will return a valid jwt" do
      result = Sesame.sign("http://wearesauce.io", %{name: "Matt Weldon", id: 1})

      signature = result[:signature]

      # TODO: Add logic to decode a JWT
    end

  end

  describe "verify_signature" do
    
    test "will return an :ok atom if the signature can be verified" do 
      signing_result = Sesame.sign("http://wearesauce.io", %{name: "Matt Weldon", id: 1})
      
      verification_result = Sesame.verify(signing_result[:signature], "http://wearesauce.io")

      assert verification_result == :ok
    end

    test "will return an :error atom if the signature cannot be verified" do 
      signing_result = Sesame.sign("http://wearesauce.io", %{name: "Matt Weldon", id: 1})
      
      verification_result = Sesame.verify(signing_result[:signature], "http://google.com")

      assert verification_result == :error
    end

    test "fails gracefully when nil signature passed" do 
      verification_result = Sesame.verify(nil, "http://google.com")

      assert verification_result == :error
    end

  end

end
