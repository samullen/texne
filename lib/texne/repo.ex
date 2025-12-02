defmodule Texne.Repo do
  use Ecto.Repo,
    otp_app: :texne,
    adapter: Ecto.Adapters.Postgres
end
