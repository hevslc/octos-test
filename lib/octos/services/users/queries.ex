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
    |> User.changeset(%{enabled: false})
    |> Repo.update()
  end

  @doc """
  Fetch users by filters
  filter is of type:
    %{
      "user" => %{
        "name" => ["Dr. Henry Wu"],
        "email" => []
      }
      "camera" => %{
        "name" => ["Camera 1", "Camera 2"],
        "brand" => ["Hikvision"]
      }
    }
  """
  def fetch_users_by(filters) do
    filter_queries = build_filter_queries(filters)

    """
      SELECT DISTINCT u.name, u.email
      FROM users u
      LEFT JOIN cameras c ON c.user_id = u.id
      WHERE #{filter_queries}
    """
    |> Repo.query!()
    |> Map.get(:rows)
    |> Enum.map(fn [name, email] -> %{name: name, email: email} end)
  end

  defp build_filter_queries(filters) do
    filters
    |> Enum.flat_map(fn {table, fields} ->
      Enum.map(fields, fn {field, values} ->
        "#{alias_table(table)}.#{field} IN ('#{Enum.join(values, "', '")}')"
      end)
    end)
    |> Enum.join(" AND ")
  end

  defp alias_table("user"), do: "u"
  defp alias_table("camera"), do: "c"
end
