defmodule PromoWeb.PromoCodeController do
  use PromoWeb, :controller

  alias Promo.PromoCodes
  action_fallback PromoWeb.FallbackController

  def create(conn, params) do
    with {:ok, promocode} <- PromoCodes.create_promocodes(params) do
      conn
      |> put_status(:created)
      |> render("new.json", promocode: promocode)
    end
  end

  def index(conn, %{"status" => "active"}) do
    conn
    |> put_status(:ok)
    |> render("index.json", active_codes: PromoCodes.active_promocodes())
  end

  def index(conn, _) do
    conn
    |> put_status(:ok)
    |> render("index.json", promocodes: PromoCodes.all_promocodes())
  end

  def update(conn, %{"id" => code, "radius" => _radius} = params) do
    update_response(conn, code, params)
  end

  def update(conn, %{"id" => code, "status" => _status} = params) do
    update_response(conn, code, params)
  end

  defp update_response(conn, code, params) do
    case PromoCodes.get_promocode(code) do
      nil ->
        conn
        |> put_status(422)
        |> render("error.json", does_not_exist: "promocode do not exist")

      promocode ->
        with {:ok, updated_promocode} <- PromoCodes.update_promocode(promocode, params) do
          conn
          |> put_status(:ok)
          |> render("show.json", updated_promocode: updated_promocode)
        end
    end
  end
end
