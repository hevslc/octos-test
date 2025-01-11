defmodule Octos.Repo.Migrations.CreateCamerasTable do
  use Ecto.Migration

  def change do
    create table :cameras do
      add :name,                :string
      add :brand,               :string
      add :enabled,             :boolean, default: true
      add :user_id, references(:users, on_delete: :nothing)
      timestamps()
    end

    create unique_index(:cameras, [:name])
  end
end
