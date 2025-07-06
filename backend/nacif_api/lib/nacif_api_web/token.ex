defmodule NacifApiWeb.Token do
  alias NacifApiWeb.Endpoint
  alias Phoenix.Token

  @sign_salt "nacif_api_supersecret"

  def sign(user) do
    Token.sign(Endpoint, @sign_salt, %{user_id: user.id})
  end

  def verify(token) do
    case Token.verify(Endpoint, @sign_salt, token, max_age: 300) do
      {:ok, %{user_id: user_id}} -> {:ok, user_id}
      {:ok, %{"user_id" => user_id}} -> {:ok, user_id}
      {:error, _} -> {:error, :unauthorized}
    end
  end
end
