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
  @spec create_promocodes(map) :: {:ok, map} | {:error, Ecto.Changeset.t()}
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

  @doc """
  gets all promocodes in the database
  """
  @spec all_promocodes :: [%PromoCode{}, ...] | []
  def all_promocodes do
    PromoCode
    |> Repo.all()
  end

  @doc """
  Takes in a promocode as the first argument and updates it with the given attributes.
  Attributes that can be updated are the status and radius of a specific promocode.
  """
  @spec update_promocode(%PromoCode{}, map()) ::
          {:ok, %PromoCode{}} | {:error, Ecto.Changeset.t()}
  def update_promocode(promocode, params) do
    params = params |> Map.put("number_of_codes", 1)

    promocode
    |> PromoCode.changeset(params)
    |> Repo.update()
  end

  @doc """
  gets a promocode using the code.
  """
  @spec get_promocode(String.t()) :: %PromoCode{} | nil
  def get_promocode(code) do
    PromoCode
    |> Repo.get(code)
  end

  @doc """
  confirms the format of the coordinates and returns true if the distance between origin and destination is within range
  """
  @spec validate_cordinates(String.t(), String.t(), String.t()) ::
          boolean() | :wrong_destination | :invalid_cordinates
  def validate_cordinates(destination, origin, code) do
    if valid_cordinates?(destination) and valid_cordinates?(origin) do
      destination = _get_cordinates_list_of_floats(destination)
      origin = _get_cordinates_list_of_floats(origin)
      cordinates_range_with_range?(destination, origin, code)
    else
      :invalid_cordinates
    end
  end

  defp cordinates_range_with_range?(destination, origin, code) do
    promocode = get_promocode(code)

    if destination == _get_cordinates_list_of_floats(promocode.event_venue) do
      promocode.radius <=
        abs(
          Geocalc.distance_between(
            destination,
            origin
          )
        )
    else
      :wrong_destination
    end
  end

  @spec valid_cordinates?(String.t()) :: boolean
  defp valid_cordinates?(cordinates) do
    cordinates = cordinates |> String.replace(" ", "")

    cordinates_regex =
      ~r/^[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?),\s*[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)$/

    Regex.match?(cordinates_regex, cordinates)
  end

  defp _get_cordinates_list_of_floats(cordinates) do
    cordinates = cordinates |> String.replace(" ", "")

    [{latitude, ""}, {longitude, ""}] =
      cordinates
      |> String.split(",")
      |> Enum.map(fn cordinate -> Float.parse(cordinate) end)

    [latitude, longitude]
  end
end
