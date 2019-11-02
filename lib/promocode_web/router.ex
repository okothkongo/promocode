defmodule PromoCodeWeb.Router do
  use PromoCodeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PromoCodeWeb do
    pipe_through :api
  end
end
