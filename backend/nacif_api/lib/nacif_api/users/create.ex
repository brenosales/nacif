defmodule NacifApi.Users.Create do
  alias NacifApi.Users.User
  alias NacifApi.Repo

  def call(params) do
    params
    |> User.changeset()
    |> Repo.insert()
  end
end
