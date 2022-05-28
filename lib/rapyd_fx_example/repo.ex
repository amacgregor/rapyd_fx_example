defmodule RapydFxExample.Repo do
  use Ecto.Repo,
    otp_app: :rapyd_fx_example,
    adapter: Ecto.Adapters.Postgres
end
