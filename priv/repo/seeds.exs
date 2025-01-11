# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Octos.Repo.insert!(%Octos.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


defmodule Seeds do
  alias Octos.Repo
  alias Octos.Services.Cameras.Queries, as: Cameras
  alias Octos.Models.User

  def seed_database do
    IO.puts("Populating the database...")

    names = random_names()

    seed_active_users(names)
    seed_inactive_users(names)

    IO.puts("Database populated successfully!")
  end

  defp seed_active_users(names) do
    0..997
    |> Enum.each(fn it_user ->
      user = it_user |> mount_user(names, true) |> Repo.insert!()

      cameras = Enum.map(1..50, fn it_cam -> mount_camera(it_cam, user, random_status()) end)
      Cameras.create_many(cameras)
    end)
  end

  defp seed_inactive_users(names) do
    998..999
    |> Enum.each(fn it_user ->
      user = it_user |> mount_user(names, false) |> Repo.insert!()

      cameras = Enum.map(1..50, fn it_cam -> mount_camera(it_cam, user, false) end)
      Cameras.create_many(cameras)
    end)
  end

  defp random_brand do
    ["Intelbras", "Hikvision", "Giga", "Vivotek", "Nikon", "Sony"]
    |> Enum.random()
  end

  defp random_status do
    Enum.random([true, false])
  end

  defp first_names do
    ["Ana", "João", "Maria", "Carlos", "Luciana",
    "Pedro", "Carolina", "José", "Geovana", "Ricardo"]
  end

  defp second_names do
    ["Silva", "Souza", "Pereira", "Oliveira", "Santos",
    "Ferreira", "Almeida", "Costa", "Gomes", "Martins"]
  end

  defp surnames do
    ["Costa", "Lima", "Carvalho", "Rocha", "Fernandes",
    "Barros", "Monteiro", "Mendes", "Rodrigues", "Freitas"]
  end

  defp random_names do
    for name1 <- first_names(),
        name2 <- second_names(),
        name3 <- surnames()
    do
      "#{name1} #{name2} #{name3}"
    end
  end

  defp mount_user(it, names, enabled) do
    %User{
      name: Enum.at(names, it),
      email: "user_#{it}@example.com",
      encrypted_password: "password123",
      enabled: enabled
    }
  end

  defp mount_camera(it_cam, user, enabled) do
    timestamp = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    brand = random_brand()

    %{
      name: "#{brand} #{user.id}-#{it_cam}",
      brand: brand,
      enabled: enabled,
      user_id: user.id,
      inserted_at: timestamp,
      updated_at: timestamp
    }
  end
end

Seeds.seed_database()
