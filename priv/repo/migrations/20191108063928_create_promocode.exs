defmodule Promo.Repo.Migrations.CreatePromocode do
  @moduledoc false
  use Ecto.Migration

  def change do
    create table(:promocodes, primary_key: false) do
      add :code, :string, primary_key: true
      add :event_venue, :string
      add :amount, :float
      add :status, :string, default: "active"
      add :number_of_rides, :integer
      add :end_date, :date
      add :start_date, :date
      add :radius, :float

      timestamps()
    end
  end
end
