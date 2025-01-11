defmodule Octos.Services.Cameras.QueriesTest do
  use Octos.DataCase
  import Mock
  alias Octos.Models.{Camera, User}
  alias Octos.Repo
  alias Octos.Services.Cameras.Queries, as: Cameras
  alias Octos.Services.Users.Queries, as: Users

  describe "create/1" do
    setup do
      user = Repo.insert!(%User{id: 1, name: "Test User", email: "test@example.com"})
      {:ok, user: user}
    end

    test "when attributes are valid", %{user: user} do
      attrs = %{name: "Camera 1", brand: "Brand A", user_id: user.id}
      expected = %{name: "Camera 1", brand: "Brand A", user_id: user.id, enabled: true}
      assert {:ok, created_camera} = Cameras.create(attrs)
      assert Map.take(created_camera, [:name, :brand, :user_id, :enabled]) == expected
    end

    test "when attributes are not valid" do
      attrs = %{name: nil, brand: "Brand A"}
      assert {:error, changeset} = Cameras.create(attrs)
      refute changeset.valid?
    end
  end

  describe "create_many/1" do
    setup do
      user = Repo.insert!(%User{id: 1, name: "Jeff Goldblum", email: "jg@example.com"})
      {:ok, user: user}
    end

    test "creates multiple cameras", %{user: user} do
      timestamp = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
      base_camera = %{user_id: user.id, inserted_at: timestamp, updated_at: timestamp}

      cameras = [
        %{name: "Camera 1", brand: "Brand A"} |> Map.merge(base_camera),
        %{name: "Camera 2", brand: "Brand B"} |> Map.merge(base_camera)
      ]

      assert {2, _} = Cameras.create_many(cameras)
    end
  end

  describe "disable/1" do
    setup do
      user1 = %User{name: "Jeff Goldblum", email: "jg@example.com"} |> Repo.insert!()
      camera11 = %Camera{name: "Camera 1.1", brand: "Brand A", user_id: user1.id} |> Repo.insert!()
      camera12 = %Camera{name: "Camera 1.2", brand: "Brand A", user_id: user1.id} |> Repo.insert!()

      user2 = %User{name: "Dr. Henry Wu", email: "dr.hw@example.com"} |> Repo.insert!()
      camera21 = %Camera{name: "Camera 2.1", brand: "Brand A", user_id: user2.id} |> Repo.insert!()

      %{user1: user1, user2: user2, camera11: camera11, camera12: camera12, camera21: camera21}
    end

    test "when related user has another camera active", %{user1: user, camera11: camera} do
      assert {:ok, updated_camera} = Cameras.disable(camera.id)
      assert updated_camera.enabled == false
      assert updated_camera.id == camera.id
      assert user.enabled == true
    end

    test "when related user has no another camera active", %{camera21: camera} do
      with_mock Users, [disable_one: fn _user_id -> :ok end] do

        assert {:ok, updated_camera} = Cameras.disable(camera.id)
        assert updated_camera.enabled == false
        assert updated_camera.id == camera.id
        assert called Users.disable_one(camera.user_id)
      end
    end
  end

  describe "get_enabled_user_cameras/1" do
    setup do
      user = Repo.insert!(%User{id: 1, name: "Alan Grant", email: "ag@example.com"})
      Repo.insert!(%Camera{name: "Camera 1", brand: "Brand A", enabled: true, user_id: user.id})
      Repo.insert!(%Camera{name: "Camera 2", brand: "Brand B", enabled: false, user_id: user.id})
      :ok
    end

    test "returns only enabled cameras for the user" do
      cameras = Cameras.get_enabled_user_cameras(1)
      assert length(cameras) == 1
      assert Enum.all?(cameras, & &1.enabled)
    end
  end

  describe "fetch_users_cameras/2" do
    setup do
      %{
        user1: Repo.insert!(%User{id: 1, name: "Dr. Henry Wu", enabled: true}),
        user2: Repo.insert!(%User{id: 2, name: "Alan Grant", enabled: false}),
        camera11: Repo.insert!(%Camera{name: "Camera 1.1", brand: "Brand A", enabled: true, user_id: 1}),
        camera12: Repo.insert!(%Camera{name: "Camera 1.2", brand: "Brand B", enabled: false, user_id: 1}),
        camera13: Repo.insert!(%Camera{name: "Camera 1.3", brand: "Brand C", enabled: true, user_id: 1}),
        camera21: Repo.insert!(%Camera{name: "Camera 2.1", brand: "Brand B", enabled: false, user_id: 2})
    }
  end

    test "fetches cameras grouped by users", %{user1: user1, user2: user2, camera11: camera11, camera13: camera13} do
      result = Cameras.fetch_users_cameras(%{"order" => "desc"})

      expected_user_cameras_1 = Map.take(user1, [:name, :enabled, :updated_at]) |> Map.put(:cameras, [
        %{"brand" => camera13.brand, "name" => camera13.name, "enabled" => camera13.enabled},
        %{"brand" => camera11.brand, "name" => camera11.name, "enabled" => camera11.enabled},
      ])

      expected_user_cameras_2 = Map.take(user2, [:name, :enabled, :updated_at]) |> Map.put(:cameras, [])

      # In ELixir, the order of the objects is inderterministic
      assert (
        (result == [expected_user_cameras_1, expected_user_cameras_2]) ||
        (result == [expected_user_cameras_2, expected_user_cameras_1])
      )
    end

    test "applies a filter and ordering", %{user1: user, camera11: camera11, camera13: camera13} do
      result = Cameras.fetch_users_cameras(%{"filter" => "Camera 1", "order" => "asc"})

      assert [user_found] = result
      assert user_found[:name] == user.name
      assert user_found[:cameras] == [
        %{"brand" => camera11.brand, "name" => camera11.name, "enabled" => camera11.enabled},
        %{"brand" => camera13.brand, "name" => camera13.name, "enabled" => camera13.enabled},
      ]
    end
  end
end
