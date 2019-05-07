defmodule YoutubeEx.Repo.Migrations.CreateContentPolicies do
  use Ecto.Migration

  def change do
    create table(:content_policies, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :update_video, :boolean, default: false, null: false
      add :delete_video, :boolean, default: false, null: false
      add :create_video_format, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:content_policies, [:user_id])
  end
end
