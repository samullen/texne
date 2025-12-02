# Texne

Is a simple Phoenix/LiveView application to pull 3 articles from a Pinecone
database, and submit them to Grok to answer the user's question.

```mermaid
sequenceDiagram
  User->>Texne: Asks a question
  Text-->>User: Show "asking..." display
  Texne->>Pinecone: Queries DB with user's question
  Pinecone->>Texne: Responds with 3 articles matching query
  Texne->>Grok: Asks grok user question including 3 articles
  Grok->>Texne: Reponds with results
  Texne->>User: Displays Grok's response
```
To start your Phoenix server:

* Run `mix setup` to install and setup dependencies
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

* Official website: https://www.phoenixframework.org/
* Guides: https://hexdocs.pm/phoenix/overview.html
* Docs: https://hexdocs.pm/phoenix
* Forum: https://elixirforum.com/c/phoenix-forum
* Source: https://github.com/phoenixframework/phoenix
