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

  test "active_promocodes/0 returns all active promocodes", %{attrs: attrs} do
    PromoCodes.create_promocodes(attrs)

    promocodes = PromoCodes.active_promocodes()

    refute [] == promocodes
    assert 10 == promocodes |> Enum.count()
  end

  test "promocodes/0 returns all promocodes", %{attrs: attrs} do
    PromoCodes.create_promocodes(attrs)
    promocodes = PromoCodes.all_promocodes()
    assert 10 == promocodes |> Enum.count()
    refute [] == promocodes
  end

  test "update_promocode/2 updates a promocode with new attributes", %{attrs: attrs} do
    PromoCodes.create_promocodes(attrs)
    [promocode] = PromoCode |> Repo.all() |> Enum.take(1)

    {:ok, updated_promocode} = PromoCodes.update_promocode(promocode, %{"status" => "inactive"})

    assert "inactive" == updated_promocode.status
    refute "active" == updated_promocode.status
  end

  test "get_promocode/1 takes in a specific code and returns the promocode", %{attrs: attrs} do
    PromoCodes.create_promocodes(attrs)
    [promocode] = PromoCode |> Repo.all() |> Enum.take(1)

    promo = PromoCodes.get_promocode(promocode.code)

    refute nil == promo
    assert promocode == promo
  end
end
