defmodule Promo.PromoodeControllerTest do
  use PromoWeb.ConnCase

  alias Promo.PromoCode
  alias Promo.PromoCodes
  alias Promo.Repo
  alias PromoWeb.ChangesetView
  alias PromoWeb.PromoCodeView

  setup do
    attrs = %{
      "amount" => 300,
      "end_date" => "2019-10-11",
      "event_venue" => "kisumu",
      "number_of_codes" => 4,
      "number_of_rides" => 3,
      "radius" => 3,
      "start_date" => "2019-10-10"
    }

    [attrs: attrs]
  end

  test "create renders codes details", %{conn: conn, attrs: attrs} do
    conn =
      post(
        conn,
        Routes.promo_code_path(conn, :create, attrs)
      )

    assert json_response(conn, 201) == render_json(PromoCodeView, "new.json", conn.assigns)
  end

  test "create/2 with invalid renders errors", %{conn: conn} do
    conn =
      post(
        conn,
        Routes.promo_code_path(conn, :create, %{})
      )

    assert json_response(conn, 422) == render_json(ChangesetView, "error.json", conn.assigns)
  end

  test "all active promocodes can be retrieved", %{conn: conn} do
    conn = get(conn, "api/promocodes?status=active")

    assert json_response(conn, 200) == render_json(PromoCodeView, "index.json", conn.assigns)
  end

  test "all  promocodes can be retrieved", %{conn: conn} do
    conn =
      get(
        conn,
        Routes.promo_code_path(conn, :index)
      )

    assert json_response(conn, 200) == render_json(PromoCodeView, "index.json", conn.assigns)
  end

  test "promocode message sent when updating non-existing code", %{conn: conn} do
    conn = patch(conn, "api/promocodes/s?status=inactive")

    assert json_response(conn, 422) == render_json(PromoCodeView, "error.json", conn.assigns)
  end

  test "promocode can be updated", %{conn: conn, attrs: attrs} do
    PromoCodes.create_promocodes(attrs)
    [promocode] = PromoCode |> Repo.all() |> Enum.take(1)
    conn = patch(conn, "api/promocodes/#{promocode.code}?status=inactive")

    assert json_response(conn, 200) == render_json(PromoCodeView, "show.json", conn.assigns)
  end

  defp render_json(module, template, assigns) do
    assigns = Map.new(assigns)

    template
    |> module.render(assigns)
    |> Jason.encode!()
    |> Jason.decode!()
  end
end
