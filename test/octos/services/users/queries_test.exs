defmodule Octos.Services.Users.QueriesTest do
  use Octos.DataCase
  alias Octos.Repo
  alias Octos.Models.{Camera, User}
  alias Octos.Services.Users.Queries, as: Users

  describe "create/1" do
    test "when attributes are valid" do
      attrs = %{name: "Dennis Nedry", email: "hahaha@example.com"}
      expected = %{name: "Dennis Nedry", email: "hahaha@example.com", enabled: true}
      assert {:ok, created_user} = Users.create(attrs)
      assert Map.take(created_user, [:name, :email, :enabled]) == expected
    end
  end

  describe "create_many/1" do
    test "creates multiple users" do
      timestamp = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
      base_user = %{inserted_at: timestamp, updated_at: timestamp}

      users = [
        %{name: "Dennis Nedry", email: "hahaha@example.com"} |> Map.merge(base_user),
        %{name: "Ellie Sattler", email: "es@example.com"} |> Map.merge(base_user)
      ]

      assert {2, _} = Users.create_many(users)
    end
  end

  describe "disable_one/1" do
    test "disables user by id" do
      user = Repo.insert!(%User{name: "Dennis Nedry", email: "hahaha@example.com"})

      Users.disable_one(user.id)

      updated_user = Repo.get!(User, user.id)
      assert updated_user.enabled == false
    end
  end

  describe "fetch_users_by/1" do
    test "fetches users by filters" do
      user1 = Repo.insert!(%User{name: "Alan Grant", email: "ag@example.com"})
      user2 = Repo.insert!(%User{name: "Jeff Goldblum", email: "jg@example.com"})
      Repo.insert!(%Camera{name: "Camera 1", brand: "Brand A", user_id: user1.id})
      Repo.insert!(%Camera{name: "Camera 1 2", brand: "Brand A", user_id: user2.id})

      filters = %{
        "user" => %{
          "name" => ["Alan Grant"]
        },
        "camera" => %{
          "name" => ["Camera 1"]
        }
      }

      assert [user] = Users.fetch_users_by(filters)
      assert user.name == user1.name
    end
  end
end
