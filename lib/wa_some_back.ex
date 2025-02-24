defmodule WaSomeBack do
  use Plug.Router
  
  require Logger
  
  plug :match
  plug :dispatch
  
  post "/generate" do
    {:ok, body, conn} = Plug.Conn.read_body(conn)
    api_key = System.get_env("GOOGLE_API_KEY")
    
    if api_key do
      url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=#{api_key}"
      headers = [{"Content-Type", "application/json"}]
      options = [timeout: 30_000, recv_timeout: 30_000]

      Logger.info(api_key)
      
      case HTTPoison.post(url, body, headers, options) do
        {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} ->
          send_resp(conn, 200, response_body)
        {:ok, %HTTPoison.Response{status_code: status_code, body: error_body}} ->
          send_resp(conn, status_code, error_body)
        {:error, reason} ->
          Logger.error("HTTP request failed: #{inspect(reason)}")
          send_resp(conn, 500, "Internal Server Error")
      end
    else
      send_resp(conn, 500, "Missing GOOGLE_API_KEY in environment variables")
    end
  end
  
  match _ do
    send_resp(conn, 404, "Not found")
  end
end
