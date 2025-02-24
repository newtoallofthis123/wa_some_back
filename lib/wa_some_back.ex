defmodule WaSomeBack do
  use Plug.Router
  require Jason
  
  require Logger
  
  plug :match
  plug :dispatch
  
  plug CORSPlug, origin: "*"

 post "/generate" do
    {:ok, body, conn} = Plug.Conn.read_body(conn)
    api_key = System.get_env("GOOGLE_API_KEY")
    
    system_instructions = "You are an expert threejs shader code generator that takes a description of a visual effect and returns a response containing GLSL code for the fragment and vertex shaders that implement the effect. 
The shaders are written for three.js so generate for that.
The code should not include any comments.
The response should be in json format like this 
{
\"frag\": \"contents\",
\"vertex\": \"contents\"
}"
    
    if api_key do
      url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=#{api_key}"
      headers = [{"Content-Type", "application/json"}]
      options = [timeout: 30_000, recv_timeout: 30_000] # Increased timeouts to 30 seconds
      
      payload = Jason.encode!(%{
        "system_instruction" => %{
          "parts" => %{"text" => system_instructions}
        },
        "contents" => %{
          "parts" => %{"text" => body}
        },
        "generationConfig" => %{ "response_mime_type" => "application/json" }
      })
      
      Logger.info(api_key)
      
      case HTTPoison.post(url, payload, headers, options) do
        {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} ->
          conn
          |> put_resp_header("access-control-allow-origin", "*")
          |> send_resp(200, response_body)
        
        {:ok, %HTTPoison.Response{status_code: status_code, body: error_body}} ->
          conn
          |> put_resp_header("access-control-allow-origin", "*")
          |> send_resp(status_code, error_body)
        
        {:error, reason} ->
          Logger.error("HTTP request failed: #{inspect(reason)}")
          conn
          |> put_resp_header("access-control-allow-origin", "*")
          |> send_resp(500, "Internal Server Error")
      end
    else
      send_resp(conn, 500, "Missing GOOGLE_API_KEY in environment variables")
    end
  end
  
  match _ do
    send_resp(conn, 404, "Not found")
  end
end
