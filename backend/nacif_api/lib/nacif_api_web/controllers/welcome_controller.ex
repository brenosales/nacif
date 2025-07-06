defmodule NacifApiWeb.WelcomeController do
  use NacifApiWeb, :controller

  def index(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(%{message: "Welcome to the Nacif API"})
  end
end
