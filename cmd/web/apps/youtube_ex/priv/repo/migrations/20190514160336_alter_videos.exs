defmodule YoutubeEx.Repo.Migrations.AlterVideos do
  use Ecto.Migration

  def change do
    alter table(:videos) do
      remove :format
    end
  end
end
