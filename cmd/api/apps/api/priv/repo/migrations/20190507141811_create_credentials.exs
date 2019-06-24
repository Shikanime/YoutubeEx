defmodule Api.Repo.Migrations.CreateCredentials do
  use Ecto.Migration

  def change do
    create table(:credentials, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :password, :string
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:credentials, [:user_id])
  end
end
