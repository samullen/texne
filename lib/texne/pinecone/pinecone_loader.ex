defmodule Texne.Pinecone.PineconeLoader do
  alias Texne.Pinecone.PineconeLoader

  @api_key Application.compile_env(:texne, :pinecone_api_key)

  defstruct title: nil, description: nil, url: nil, body: nil, tags: []

  def load do
    path = Application.get_env(:texne, :filestore_path)

    path
    |> File.ls!()
    |> Enum.map(&Path.join([path, &1]))
    |> Enum.map(&process_file/1)
    |> Enum.each(&load_file/1)
  end

  defp process_file(file_path) do
    case File.read(file_path) do
      {:ok, content} ->
        %PineconeLoader{
          title: extract(content, :title),
          description: extract(content, :description),
          url: build_url(file_path),
          body: extract(content, :body),
          tags: extract(content, :tags)
        }

      {:error, reason} ->
        IO.puts("Failed to read file #{file_path}: #{reason}")
        nil
    end
  end

  defp build_url(file_path) do
    base_url = "https://samuelmullen.com/articles/"
    filename =
      file_path
      |> Path.basename()
      |> String.replace_suffix(".md", "")
      |> String.replace(~r/^\d\d\d\d-\d\d-\d\d-/, "")

    Path.join([base_url, filename])
  end

  defp extract(content, :title) do
    Regex.run(~r/title:\s*"?(.+?)"?\n/, content)
    |> List.last()
  end

  defp extract(content, :description) do
    Regex.run(~r/description:\s*"?(.+?)"?\n/, content)
    |> List.last()
  end

  defp extract(content, :tags) do
    case Regex.run(~r/(?:tags|categories):\s*\[(.+)\]\n/, content) do
      nil ->
        []

      [_, tags] ->
        tags
        |> String.split(",")
        |> Enum.map(&String.trim/1)
        |> Enum.map(&String.trim(&1, "\""))
    end
  end

  defp extract(content, :body) do
    content
    |> String.replace(~r/\A---.+---\n/s, "")
  end

  def load_file(pinecone) do
    url =
      [
        Application.get_env(:texne, :pinecone_base_url),
        "records/namespaces/__default__/upsert"
      ]
      |> Path.join()

    Req.post!(
      url,
      headers: [
        {"Api-Key", @api_key},
        {"Content-Type", "application/x-ndjson"},
        {"X-Pinecone-API-Version", "2025-04"}
      ],
      json: %{
        _id: pinecone.url,
        text: pinecone.body,
        title: pinecone.title,
        description: pinecone.description,
        url: pinecone.url,
        categories: Enum.join(pinecone.tags, ", ")
      }
    )
  end
end
