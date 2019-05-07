defmodule YoutubeEx.Repo.Migrations.CreateActivityPolicies do
  use Ecto.Migration

  def change do
    create table(:activity_policies, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :comment_video, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:activity_policies, [:user_id])
  end
end
