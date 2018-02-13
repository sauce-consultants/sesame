defmodule Sesame.Plug.EnsureSigned do
  
  import Plug.Conn

  def init() do
    %{}
  end
  def init(opts) do
    opts
  end

  def call(conn, opts) do
    signature = conn  |> find_signature
    resource = conn |> Sesame.URI.from_conn |> URI.to_string
    
    case Sesame.verify(signature, resource) do
      :ok -> conn
      :error ->
        conn
        |> halt
        |> put_resp_content_type("text/plain")
        |> send_resp(403, "Unauthorized")
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


end