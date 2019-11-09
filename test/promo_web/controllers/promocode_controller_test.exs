defmodule Promo.PromoodeControllerTest do
  use PromoWeb.ConnCase
  alias PromoWeb.ChangesetView
  alias PromoWeb.PromoCodeView

  test "create renders codes details", %{conn: conn} do
    attrs = %{
      amount: 300,
      end_date: "2019-10-11",
      event_venue: "kisumu",
      number_of_codes: 4,
      number_of_rides: 3,
      radius: 3,
      start_date: "2019-10-10"
    }

    conn =
      post(
        conn,
        Routes.promo_code_path(conn, :create, attrs)
      )

    assert json_response(conn, 201) == render_json(PromoCodeView, "index.json", conn.assigns)
  end

  test "create/2 with invalid renders errors", %{conn: conn} do
    conn =
      post(
        conn,
        Routes.promo_code_path(conn, :create, %{})
      )

    assert json_response(conn, 422) ==
             render_json(ChangesetView, "error.json", conn.assigns)
  end

  defp render_json(module, template, assigns) do
    assigns = Map.new(assigns)

    template
    |> module.render(assigns)
    |> Jason.encode!()
    |> Jason.decode!()
  end
end
