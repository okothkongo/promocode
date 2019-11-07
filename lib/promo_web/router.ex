defmodule PromoWeb.Router do
  use PromoWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PromoWeb do
    pipe_through :api
  end
end
