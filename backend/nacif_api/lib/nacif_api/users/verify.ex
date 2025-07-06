defmodule NacifApi.Users.Verify do
  alias NacifApi.Users
  alias Users.User

  def call(%{"email" => email, "password" => password}) do
    case Users.get_by_email(%{"email" => email}) do
      {:ok, %User{} = user} -> verify(user, password)
      {:error, :not_found} -> {:error, :not_found}
    end
  end

  defp verify(user, password) do
    case Bcrypt.verify_pass(password, user.password_hash) do
      true -> {:ok, user}
      false -> {:error, :unauthorized}
    end
  end
end
