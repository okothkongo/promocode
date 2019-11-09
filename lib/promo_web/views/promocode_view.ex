defmodule PromoWeb.PromoCodeView do
  use PromoWeb, :view

  def render("new.json", %{promocode: promocode}) do
    promocode
  end
end
