defmodule Texne.AIs.Grok do
  @base_url "https://api.x.ai/v1"

  def ask(query, fun \\ nil) do
    api_key = Application.get_env(:texne, :grok_api_key)

    headers = [
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{api_key}"}
    ]

    results =
      query
      |> Texne.Pinecone.query()
      |> Jason.encode!()

    attrs = %{
      messages: [
        %{
          role: "system",
          content:
            "You are a helpful assistant who knows everything about what Samuel Mullen has written on his blog."
        },
        %{
          role: "user",
          content:
            "Here are three articles in JSON format that Samuel Mullen has written:\n#{results} including the title, text, and url of each article. Use the above articles (and no other info) to answer the following query: #{query}. Respond with markdown and two newline characters to separate paragraphs, but don't bother with headers, and include links to the articles you used where relevant."
        }
      ],
      model: "grok-4-0709",
      temperature: 0.2,
      stream: true,
      stream_options: %{
        include_usage: false
      }
    }

    Req.post!("#{@base_url}/chat/completions",
      json: attrs,
      headers: headers,
      receive_timeout: 30_000,
      into: &response_handler(&1, &2, fun)
    )
  end

  defp response_handler({:data, data}, {req, resp}, nil) do
    data
    |> String.split(~r{\n+})
    |> Enum.map(&parse_chunk/1)
    |> Enum.join("")
    |> IO.write()

    {:cont, {req, resp}}
  end

  defp response_handler({:data, data}, {req, resp}, fun) do
    data
    |> String.split(~r{\n+})
    |> Enum.map(&parse_chunk/1)
    |> fun.()

    {:cont, {req, resp}}
  end

  defp parse_chunk(""), do: nil

  defp parse_chunk("data: [DONE]"), do: nil

  defp parse_chunk(chunk) do
    chunk
    |> String.replace_prefix("data: ", "")
    |> Jason.decode!()
    |> Map.get("choices")
    |> hd()
    |> get_in(["delta", "content"])
  end
end
