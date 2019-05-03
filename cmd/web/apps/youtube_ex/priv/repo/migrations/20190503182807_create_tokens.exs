defmodule YoutubeEx.Repo.Migrations.CreateTokens do
  use Ecto.Migration

  def change do
    create table(:tokens, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :token, :string
      add :user, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create unique_index(:tokens, [:token])
    create index(:tokens, [:user])
  end
end
