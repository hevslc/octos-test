defmodule Octos.Services.Users.Queries do
  alias Octos.Repo
  alias Octos.Models.User

  def create(user_attrs) do
    user_attrs
    |> User.changeset()
    |> Repo.insert()
  end

  def create_many(users_attrs) do
    User
    |> Repo.insert_all(users_attrs)
  end

  def disable_one(user_id) do
    User
    |> Repo.get!(user_id)
    |> Map.put(:enabled, false)
    |> User.changeset()
    |> Repo.update()
  end
end
