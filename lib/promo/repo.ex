defmodule Promo.Repo do
  use Ecto.Repo,
    otp_app: :promo,
    adapter: Ecto.Adapters.Postgres
end
