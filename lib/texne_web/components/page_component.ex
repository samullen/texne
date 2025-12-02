defmodule TexneWeb.PageComponent do
  # In Phoenix apps, the line is typically: use MyAppWeb, :html
  use Phoenix.Component

  attr :question, :string, default: nil
  attr :answer, :string, default: nil

  def index(assigns) do
    ~H"""
    <div class="max-w-4xl mx-auto p-6 space-y-6">
      <!-- Header -->
      <div class="text-center">
        <h1 class="text-3xl font-bold text-slate-300 mb-4">Hi, I'm Texne!</h1>
        <p class="text-lg text-gray-200">I'm here to answer all your questions about articles Samuel has written.</p>
      </div>

      <!-- Question Form -->
      <div class="bg-white shadow-sm border border-gray-200 rounded-md p-6">
        <.form :let={f} for={@form} class="space-y-4" method="post" phx-submit="submit_question">
          <div>
            <textarea
              id="question"
              name="question"
              rows="3"
              class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 resize-none text-gray-900"
              placeholder="What would you like to know about Samuel's articles?"
              required
            ></textarea>
          </div>
          <div class="flex justify-end">
            <span class="text-gray-600 italic mr-4" :if={@running}>
              Thinking...
            </span>

            <button
              type="submit"
              class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-md transition-colors duration-200"
              :if={!@running}
            >
              Ask Texne
            </button>
          </div>
        </.form>
      </div>

      <!-- Response Area -->
      <%= if @question do %>
        <div class="bg-gray-50 border border-gray-200 rounded-md p-6">
          <h2 class="text-xl font-semibold text-gray-900 mb-4">Question</h2>
          <div class="max-w-none text-gray-900">
            <%= @question %>
          </div>
        </div>
      <% end %>

      <%= if String.length(@answer) > 0 do %>
        <div class="bg-gray-50 border border-gray-200 rounded-md p-6">
          <h2 class="text-xl font-semibold text-gray-900 mb-4">Response</h2>
          <div id="answer" class="max-w-none text-gray-900 [&_p]:mb-4 [&_a]:underline [&_a]:text-blue-600 [&_a:hover]:text-blue-800 [&_code]:text-pink-600 [&_code]:bg-gray-100 [&_code]:px-1 [&_code]:rounded [&_pre]:bg-gray-800 [&_pre]:text-white [&_pre]:p-4 [&_pre]:rounded-md [&_pre]:overflow-x-auto [&_pre]:mb-4 [&_pre_code]:bg-transparent [&_pre_code]:text-inherit [&_pre_code]:p-0">
            <%= @answer %>
          </div>
        </div>
      <% end %>

      <!-- Related Articles -->
      <%= if false do %>
      <div class="bg-white border border-gray-200 rounded-md p-6">
        <h2 class="text-xl font-semibold text-gray-900 mb-4">Related Articles</h2>
        <div class="space-y-3">
          <div class="border-b border-gray-100 pb-3 last:border-b-0 last:pb-0">
            <a href="#" class="text-blue-600 hover:text-blue-800 font-medium block">
              Sample Article Title About Development
            </a>
            <p class="text-sm text-gray-600 mt-1">A brief description of the article content and main topics covered...</p>
          </div>
          <div class="border-b border-gray-100 pb-3 last:border-b-0 last:pb-0">
            <a href="#" class="text-blue-600 hover:text-blue-800 font-medium block">
              Another Interesting Article on Programming
            </a>
            <p class="text-sm text-gray-600 mt-1">More details about this article and what readers can expect to learn...</p>
          </div>
          <div class="border-b border-gray-100 pb-3 last:border-b-0 last:pb-0">
            <a href="#" class="text-blue-600 hover:text-blue-800 font-medium block">
              Technical Deep Dive into Web Technologies
            </a>
            <p class="text-sm text-gray-600 mt-1">An exploration of modern web development practices and tools...</p>
          </div>
        </div>
      </div>
    <% end %>
    </div>
    """
  end

end
