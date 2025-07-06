defmodule NacifApi.Repo do
  use Ecto.Repo,
    otp_app: :nacif_api,
    adapter: Ecto.Adapters.Postgres
end
