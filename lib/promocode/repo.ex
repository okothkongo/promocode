defmodule Promo.Repo do
  use Ecto.Repo,
    otp_app: :promocode,
    adapter: Ecto.Adapters.Postgres
end
