defmodule Sesame.URI do

  def from_conn(conn) do
    query = case conn |> strip_signature do
              "" -> nil
              query -> query
            end
            
    %URI{
      scheme: conn.scheme |> to_string,
      host: conn.host,
      port: conn.port,
      path: conn.request_path,
      query: query
    }
  end
  
  defp strip_signature(conn) do
    conn.query_string
    |> String.split("&")
    |> Enum.map(fn(part) ->
      case part |> String.split("=") do
        ["signature", signature] -> nil
        _ -> part
      end
    end)
    |> Enum.reject(fn(x) -> x == nil end)
    |> Enum.join("&")
  end

end