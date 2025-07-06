defmodule NacifApi.Users.Delete do
  alias NacifApi.Users.User
  alias NacifApi.Repo

  def call(%{"id" => id}) do
    case Repo.get(User, id) do
      nil -> {:error, :not_found}
      user -> Repo.delete(user)
    end
  end
end
