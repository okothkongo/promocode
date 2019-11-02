#!/usr/bin/env bash
mix ecto.create
mix ecto.migrate 
mix run priv/repo/seeds.exs
mix phx.server
