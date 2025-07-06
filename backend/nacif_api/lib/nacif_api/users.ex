defmodule NacifApi.Users do
  alias NacifApi.Users.Create
  alias NacifApi.Users.Delete
  alias NacifApi.Users.Get
  alias NacifApi.Users.Update
  alias NacifApi.Users.Verify

  defdelegate create(params), to: Create, as: :call
  defdelegate delete(params), to: Delete, as: :call
  defdelegate get(id), to: Get, as: :call
  defdelegate get_by_email(params), to: Get, as: :call
  defdelegate update(params), to: Update, as: :call
  defdelegate login(params), to: Verify, as: :call
end
