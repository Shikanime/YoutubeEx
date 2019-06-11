defmodule Api.Repo.Migrations.AlterUsers do
  use Ecto.Migration

  def change do
    drop unique_index(:users, [:pseudo])
    create unique_index(:users, [:username])
  end
end
