defmodule YoutubeEx.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :body, :string
      add :user, references(:users, on_delete: :nothing, type: :binary_id)
      add :video, references(:videos, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:comments, [:user])
    create index(:comments, [:video])
  end
end
