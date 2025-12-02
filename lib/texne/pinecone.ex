defmodule Texne.Pinecone do
  defdelegate load, to: Texne.Pinecone.PineconeLoader

  def query(q) do
    api_key = Application.get_env(:texne, :pinecone_api_key)

    url =
      [
        Application.get_env(:texne, :pinecone_base_url),
        "records/namespaces/__default__/search"
      ]
      |> Path.join()

    Req.post!(
      url,
      headers: [
        {"Api-Key", api_key},
        {"Content-Type", "application/json"},
        {"X-Pinecone-API-Version", "2025-04"}
      ],
      json: %{
        query: %{
          inputs: %{text: q},
          top_k: 3
        },
        fields: ~w[title text url]
      }
    )
    |> Map.get(:body)
    |> get_in(["result", "hits"])
  end
end
