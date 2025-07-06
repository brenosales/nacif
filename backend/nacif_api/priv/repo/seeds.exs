# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     NacifApi.Repo.insert!(%NacifApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# Create a test user for development
alias NacifApi.Users.User

# Check if test user already exists
case NacifApi.Repo.get_by(User, email: "test@example.com") do
  nil ->
    # Create test user
    %User{}
    |> User.changeset(%{
      name: "Test User",
      email: "test@example.com",
      password: "password123",
      cep: "12345678"
    })
    |> NacifApi.Repo.insert!()

    IO.puts("✅ Test user created: test@example.com / password123")

  _user ->
    IO.puts("ℹ️ Test user already exists: test@example.com / password123")
end
