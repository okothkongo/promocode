defmodule PromoWeb.PromoCodeView do
  use PromoWeb, :view

  def render("new.json", %{promocode: promocode}) do
    promocode
  end

  def render("index.json", %{active_codes: active_codes}) do
    Enum.map(active_codes, fn promocode -> promocode.code end)
  end

  def render("index.json", %{promocodes: promocodes}) do
    Enum.map(promocodes, fn promocode -> promocode.code end)
  end

  def render("error.json", %{does_not_exist: _message}) do
    %{error: "promocode with given code does not exist"}
  end

  def render("show.json", %{updated_promocode: updated_promocode}) do
    updated_promocode |> Map.from_struct() |> Map.drop([:__meta__])
  end
end
