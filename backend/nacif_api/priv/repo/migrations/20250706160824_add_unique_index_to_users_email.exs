defmodule NacifApi.Repo.Migrations.AddUniqueIndexToUsersEmail do
  use Ecto.Migration

  def change do
    # Remove duplicate emails before creating the unique index
    execute """
    DELETE FROM users
    WHERE id NOT IN (
      SELECT MIN(id)
      FROM users
      GROUP BY email
    )
    """

    create unique_index(:users, [:email])
  end
end
