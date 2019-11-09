defmodule Promo.PromoCodesTest do
  @moduledoc """
  This module contains Unit tests of all operations performed on the promocode.It generally
  entails a single operation i.e simplest operation possible.
  You encourage to limit your test to those which entails single operation i.e output of a single
  function
  """
  use ExUnit.Case, async: true
  use Promo.DataCase
  alias Promo.PromoCode
  alias Promo.PromoCodes

  alias Promo.Repo
  doctest PromoCodes

  setup do
    attrs = %{
      "number_of_codes" => 10,
      "event_venue" => "kisumu",
      "number_of_rides" => 3,
      "radius" => 3.0,
      "amount" => 300,
      "start_date" => "2019-10-10",
      "end_date" => "2019-10-11"
    }

    [attrs: attrs]
  end

  test "create_promocodes/1 creates promocodes with valid arguement ", %{attrs: attrs} do
    {:ok, promocodes} = PromoCodes.create_promocodes(attrs)
    assert promocodes.event_venue == "kisumu"
    all_created_promocodes = Repo.all(PromoCode)
    assert Enum.count(all_created_promocodes) == 10
  end

  test " with invalid arguement create_promocodes/1 do not create promocodes" do
    assert {:error, changeset} = PromoCodes.create_promocodes(%{})
    assert changeset.valid? == false
    assert Repo.all(PromoCode) == []
  end
end
