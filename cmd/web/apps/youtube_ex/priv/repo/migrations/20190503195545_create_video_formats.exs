defmodule YoutubeEx.Repo.Migrations.CreateVideoFormats do
  use Ecto.Migration

  def change do
    create table(:video_formats, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :code, :string
      add :uri, :string
      add :video, references(:videos, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:video_formats, [:video])
  end
end
