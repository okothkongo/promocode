defmodule Promo.PromoCode do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  @primary_key {:code, :string, autogenerate: false}
  schema "promocodes" do
    field :event_venue, :string
    field :amount, :float
    field :status, :string, default: "active"
    field :number_of_rides, :integer
    field :start_date, :date
    field :end_date, :date
    field :radius, :float
    field :number_of_codes, :integer, virtual: true
    timestamps()
  end

  def changeset(promocode, attrs \\ {}) do
    promocode
    |> cast(attrs, [
      :code,
      :event_venue,
      :amount,
      :status,
      :number_of_rides,
      :radius,
      :start_date,
      :end_date,
      :number_of_codes
    ])
    |> validate_required([
      :event_venue,
      :amount,
      :number_of_rides,
      :start_date,
      :end_date,
      :radius,
      :number_of_codes
    ])
  end
end
