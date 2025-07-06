defmodule NacifApiWeb.UsersJSON do
  #alias NacifApi.Users.User

  def create(%{user: user}) do
    %{
      message: "User created successfully",
      data: data(user)
    }
  end

  def delete(%{user: user}) do
    %{
      message: "User deleted successfully",
      data: data(user)
    }
  end

  def login(%{token: token}) do
    %{
      message: "User authenticated successfully",
      data: %{bearer: token}
    }
  end

  def show(%{user: user}) do
    %{
      data: data(user)
    }
  end

  def update(%{user: user}) do
    %{
      message: "User updated successfully",
      data: data(user)
    }
  end

  defp data(user) do
    %{
      id: user.id,
      name: user.name,
      email: user.email,
      cep: user.cep
    }
  end
end
