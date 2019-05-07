defmodule YoutubeEx.Repo.Migrations.CreateAccountPolicies do
  use Ecto.Migration

  def change do
    create table(:account_policies, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :get_user, :boolean, default: false, null: false
      add :update_user, :boolean, default: false, null: false
      add :delete_user, :boolean, default: false, null: false
      add :create_video, :boolean, default: false, null: false
      add :user, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:account_policies, [:user])
  end
end
