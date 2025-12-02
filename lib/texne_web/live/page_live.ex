defmodule TexneWeb.PageLive do
  use TexneWeb, :live_view

  alias TexneWeb.PageComponent
  alias Texne.AIs.Grok

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:question, nil)
      |> assign(:answer, "")
      |> assign(:form, to_form(%{question: ""}))
      |> assign(:data_stream, nil)
      |> assign(:running, false)

    {:ok, socket}
  end

  def render(assigns) do
    PageComponent.index(assigns)
  end

  def handle_event("submit_question", %{"question" => question}, socket) do
    pid = self()

    socket =
      socket
      |> assign(:answer, "")
      |> assign(:question, question)
      |> assign(:running, true)
      |> start_async(:data_stream, fn ->
        Grok.ask(question, &(stream_response(&1, pid)))
      end)

    {:noreply, socket}
  end

  def handle_async(:data_stream, {:ok, data}, socket) do
    socket =
      socket
      |> assign(:running, false)
      |> push_event("answer_update", %{"answer" => socket.assigns.answer})

    {:noreply, socket}
  end

  defp stream_response(chunks, pid) do
    for chunk <- chunks, chunk != nil do
      send(pid, {:render_response_chunk, chunk})
    end
  end

  @impl true
  def handle_info({:render_response_chunk, chunk}, socket) do
    answer = socket.assigns.answer <> chunk
    socket =
      socket
      |> assign(:answer, answer)
      |> push_event("answer_update", %{"answer" => answer})

    {:noreply, assign(socket, :answer, answer)}
  end

end
