defmodule Api.Repo.Migrations.CreateVideos do
  use Ecto.Migration

  def change do
    create table(:videos, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :duration, :integer
      add :source, :string
      add :view, :integer
      add :enabled, :boolean, default: false, null: false
      add :format, :map
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:videos, [:user_id])
  end
end
