defmodule Unit.PlugTest do
  use ExUnit.Case
  use Plug.Test


  alias Sesame.Plug.EnsureSigned

  doctest Sesame

  describe "ensure signed" do

    test "will only allow user to continue if a valid signature is present" do
      result = Sesame.sign("http://wearesauce.io/foo", %{name: "Matt Weldon", id: 1})

      conn = conn(:get, "http://wearesauce.io/foo?signature=#{result[:signature]}")

      ensured_conn = EnsureSigned.call(conn, %{})
      assert ensured_conn.halted == false
    end

    test "will not allow user to continue if an invalid signature is present" do
      result = Sesame.sign("http://wearesauce.io/bar", %{name: "Matt Weldon", id: 1})

      conn = conn(:get, "http://wearesauce.io/foo?signature=#{result[:signature]}")

      ensured_conn = EnsureSigned.call(conn, %{})
      assert ensured_conn.halted == true
      assert ensured_conn.status == 401
    end

    test "ensure we can access the signature after we've checked it's been signed" do
      result = Sesame.sign("http://wearesauce.io/foo", %{name: "Matt Weldon", id: 1})

      conn = conn(:get, "http://wearesauce.io/foo?signature=#{result[:signature]}")

      ensured_conn = EnsureSigned.call(conn, %{})

      response = Sesame.current_signer(ensured_conn)

      assert response == {:ok, "1"}
    end

  end

end
