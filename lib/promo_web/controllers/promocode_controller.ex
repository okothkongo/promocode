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
end
