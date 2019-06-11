defmodule Api.Repo.Migrations.AlterVideos do
  use Ecto.Migration

  def change do
    alter table(:videos) do
      remove :format
      add :video_id, references(:videos, on_delete: :nothing, type: :binary_id)
    end

    create index(:videos, [:video_id])
  end
end
