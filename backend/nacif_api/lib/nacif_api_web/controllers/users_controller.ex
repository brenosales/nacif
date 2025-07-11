defmodule NacifApiWeb.UsersController do
  use NacifApiWeb, :controller

  alias NacifApi.Users
  alias Users.User
  alias NacifApiWeb.Token

  action_fallback NacifApiWeb.FallbackController

  def create(conn, params) do
    with {:ok, %User{} = user} <- Users.create(params) do
      conn
      |> put_status(:created)
      |> render(:create, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %User{} = user} <- Users.delete(%{"id" => id}) do
      conn
      |> put_status(:ok) #qual a convencao? retornar no content ou ok?
      |> render(:delete, user: user)
    end
  end

  def login(conn, params) do
    with {:ok, %User{} = user} <- Users.login(params) do
      token = Token.sign(user)

      conn
      |> put_status(:ok)
      |> render(:login, token: token)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, %User{} = user} <- Users.get(id) do
      conn
      |> put_status(:ok)
      |> render(:show, user: user)
    end
  end

  def show_by_email(conn, %{"email" => email}) do
    with {:ok, %User{} = user} <- Users.get_by_email(%{"email" => email}) do
      conn
      |> put_status(:ok)
      |> render(:show, user: user)
    end
  end

  def update(conn, params) do
    with {:ok, %User{} = user} <- Users.update(params) do
      conn
      |> put_status(:ok)
      |> render(:update, user: user)
    end
  end
end
