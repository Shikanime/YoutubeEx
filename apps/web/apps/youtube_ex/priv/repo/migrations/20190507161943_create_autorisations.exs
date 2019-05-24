defmodule YoutubeEx.Repo.Migrations.CreateAutorisations do
  use Ecto.Migration

  def change do
    create table(:autorisations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :update_video, :boolean, default: false, null: false
      add :delete_video, :boolean, default: false, null: false
      add :create_video_format, :boolean, default: false, null: false
      add :comment_video, :boolean, default: false, null: false
      add :update_user, :boolean, default: false, null: false
      add :delete_user, :boolean, default: false, null: false
      add :create_video, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:autorisations, [:user_id])
  end
end
