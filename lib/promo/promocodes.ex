defmodule Promo.PromoCodes do
  @moduledoc """
    This module acts as an api of interaction between external data getway(controller)
    and the database data from the controller and tranformed into a format easily understand
    by deep in this module this ensure as much minimal interaction between database
    outside as possible
  """
  alias Promo.PromoCode
  alias Promo.Repo

  @doc """
  Takes a map of attributes of promocodes or promocode to be created and returns a 
  {:ok, %{}} or {:error, %Ecto.Changeset{}}  of failure.
  """
  @spec create_promocodes(map) :: {:ok, map} | {:error, %Ecto.Changeset{}}
  def create_promocodes(attrs) do
    changeset =
      %PromoCode{}
      |> PromoCode.changeset(attrs)

    if changeset.valid? do
      changeset =
        %PromoCode{}
        |> PromoCode.changeset(Map.put(attrs, "code", _generate_code()))

      promocodes_chunks = Enum.chunk_every(list_of_all_promocodes(changeset.changes), 5000)

      Repo.transaction(fn ->
        insert_promocode_in_chunks(promocodes_chunks)
      end)
      |> sanitize_return_value
    else
      {:error, changeset}
    end
  end

  defp insert_promocode_in_chunks(promocodes_chunks) do
    Enum.map(promocodes_chunks, fn promocodes ->
      Repo.insert_all(
        PromoCode,
        promocodes,
        returning: [
          :end_date,
          :event_venue,
          :amount,
          :number_of_rides,
          :radius,
          :start_date
        ]
      )
    end)
  end

  defp sanitize_return_value({:ok, all_promocodes}) do
    {_, promocodes} = List.first(all_promocodes)

    promocode =
      promocodes
      |> List.first()
      |> create_return_map()
      |> Map.put(:number_of_codes, number_of_codes_inserted(all_promocodes))

    {:ok, promocode}
  end

  def number_of_codes_inserted(all_promocodes) do
    all_promocodes |> Enum.reduce(0, fn {n, _}, acc -> acc + n end)
  end

  defp create_return_map(promocode) do
    %{
      end_date: promocode.end_date,
      event_venue: promocode.event_venue,
      amount: promocode.amount,
      number_of_rides: promocode.number_of_rides,
      radius: promocode.radius,
      start_date: promocode.start_date
    }
  end

  defp list_of_all_promocodes(attrs) do
    1..attrs.number_of_codes
    |> Enum.map(fn _x ->
      create_promocode_map(attrs)
    end)
  end

  defp create_promocode_map(attrs) do
    attrs
    |> Map.merge(%{
      code: _generate_code(),
      amount: amount_of_each_promocode(attrs.amount, attrs.number_of_codes),
      inserted_at: current_time(),
      updated_at: current_time()
    })
    |> Map.delete(:number_of_codes)
  end

  defp current_time do
    NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
  end

  defp _generate_code do
    Ecto.UUID.generate()
    |> String.replace("-", "")
    |> String.split("", trim: true)
    |> Enum.map(fn x -> x |> String.upcase() end)
    |> Enum.join()
  end

  defp amount_of_each_promocode(amount, number_of_codes) do
    amount_of_each = amount / number_of_codes
    Float.round(amount_of_each, 2)
  end

  @doc """
  gets all active promocodes from the database.
  """
  @spec active_promocodes :: [%PromoCode{}, ...] | []
  def active_promocodes do
    PromoCode.active_promocode_query()
    |> Repo.all()
  end
end
