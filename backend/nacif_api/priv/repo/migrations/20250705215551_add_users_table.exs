defmodule NacifApi.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    create table("users") do
      add :name, :string, null: false
      add :password_hash, :string, null: false
      add :email, :string, null: false, unique: true
      add :cep, :string

      timestamps()
    end
  end
end
