defmodule Octos.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table :users do
      add :name,                :string
      add :email,               :string
      add :encrypted_password,  :string
      add :enabled,             :boolean, default: true
      timestamps()
    end
  end
end
