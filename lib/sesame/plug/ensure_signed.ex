defmodule Sesame.Plug.EnsureSigned do
  @moduledoc """
  This plug ensures that a valid JWT was provided and has been
  verified on the request.
  If one is not found, the `unauthenticated/2` function is invoked with the
  `Plug.Conn.t` object and its params.
  ## Example
      # Will call the unauthenticated/2 function on your handler
      plug Guardian.Plug.EnsureAuthenticated, handler: SomeModule
      # look in the :secret location.  You can also do simple claim checks:
      plug Guardian.Plug.EnsureAuthenticated, handler: SomeModule, key: :secret
      plug Guardian.Plug.EnsureAuthenticated, handler: SomeModule, typ: "access"
  If the handler option is not passed, `Guardian.Plug.ErrorHandler` will provide
  the default behavior.
  """
  require Logger
  import Plug.Conn

  @doc false
  def init() do
    %{}
  end
  def init(opts) do
    opts
  end

  @doc false
  def call(conn, opts) do
    
    # case Guardian.Plug.claims(conn, key) do
    #   {:ok, claims} -> conn |> check_claims(opts, claims)
    #   {:error, reason} -> handle_error(conn, {:error, reason}, opts)
    # end

    signature = conn  |> find_signature
    resource = conn |> Sesame.URI.from_conn |> URI.to_string
    
    case Sesame.verify(signature, resource) do
      :ok -> conn
      :error ->
        conn |> put_status(401) |> halt
    end
  end

  defp find_signature(conn) do
    conn.query_string
    |> String.split("&")
    |> Enum.map(fn(part) ->
      case part |> String.split("=") do
        ["signature", signature] -> signature
        _ -> nil
      end
    end)
    |> Enum.reject(fn(x) -> x == nil end)
    |> List.first
  end


  # defp handle_error(%Plug.Conn{params: params} = conn, reason, opts) do
  #   conn = conn |> assign(:guardian_failure, reason) |> halt
  #   params = Map.merge(params, %{reason: reason})
  #   {mod, meth} = Map.get(opts, :handler)

  #   apply(mod, meth, [conn, params])
  # end

  # defp check_claims(conn, opts = %{claims: claims_to_check}, claims) do
  #   claims_match =
  #     claims_to_check
  #     |> Map.keys
  #     |> Enum.all?(&(claims_to_check[&1] == claims[&1]))

  #   if claims_match do
  #     conn
  #   else
  #     handle_error(conn, {:error, :claims_do_not_match}, opts)
  #   end
  # end

end