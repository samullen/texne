defmodule TexneWeb.PageController do
  use TexneWeb, :controller

  alias Texne.AIs.Grok

  def index(conn, %{"question" => q}) do
    answer =
      q
      |> Grok.ask()
      |> Earmark.as_html!()

    render(conn, :index, answer: answer)
  end

  def index(conn, _params) do
    render(conn, :index, answer: nil)
  end
end
