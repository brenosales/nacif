defmodule NacifApi.Users.Get do
  alias NacifApi.Users.User
  alias NacifApi.Repo

  def call(id) when is_binary(id) do
    case Repo.get(User, id) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  def call(%{"email" => email}) do
    case Repo.get_by(User, email: email) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end
end
