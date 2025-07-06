defmodule NacifApiWeb.FallbackController do
  use NacifApiWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(NacifApiWeb.ErrorJSON)
    |> render(:error, status: :not_found)
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(NacifApiWeb.ErrorJSON)
    |> render(:error, status: :unauthorized)
  end

  def call(conn, {:error, changeset}) when is_struct(changeset) do
    conn
    |> put_status(:bad_request)
    |> put_view(NacifApiWeb.ErrorJSON)
    |> render(:error, changeset: changeset)
  end

end
