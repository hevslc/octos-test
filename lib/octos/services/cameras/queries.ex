defmodule Octos.Services.Cameras.Queries do
  @moduledoc """
  This module contains queries for the Cameras context.
  """
  import Ecto.Query
  alias Octos.Models.Camera
  alias Octos.Repo
  alias Octos.Services.Users.Queries, as: Users

  @field_for_filter "name"
  @field_for_ordering "name"

  def create(camera_attrs) do
    camera_attrs
    |> Camera.changeset()
    |> Repo.insert()
  end

  def create_many(cameras_attrs) do
    Repo.insert_all(Camera, cameras_attrs)
  end

  def disable(camera_id) do
    Camera
    |> Repo.get!(camera_id)
    |> Camera.changeset(%{enabled: false})
    |> Repo.update()
    |> handle_user_deactivation()
  end

  def get_enabled_user_cameras(user_id) do
    Repo.all(
      from c in Camera,
      where: c.enabled == true and c.user_id == ^user_id
    )
  end

  def fetch_users_cameras(params \\ %{}) do
    filter = Map.get(params, "filter")
    order = Map.get(params, "order")

    query =
    """
    SELECT u.name, u.enabled, u.updated_at,
           array_agg(
              jsonb_build_object(
                'name', c.name, 'brand', c.brand, 'enabled', c.enabled
              ) #{order_by_query(@field_for_ordering, order)}
           ) as cameras
    FROM cameras c
    LEFT JOIN users u ON u.id = c.user_id
    """ <> " " <>
    filter_query(@field_for_filter, filter) <> " " <>
    "GROUP BY u.name, u.enabled, u.updated_at"

    query
    |> Repo.query!()
    |> Map.get(:rows)
    |> Enum.map(fn [name, enabled, updated_at, cameras] ->
      %{
        name: name,
        enabled: enabled,
        updated_at: updated_at,
        cameras: Enum.filter(cameras, fn camera -> camera["enabled"] == true end)
      }
    end)
  end

  defp filter_query(_field, nil = _filter), do: ""
  defp filter_query(field, filter), do: "WHERE c.#{field} ILIKE '%#{filter}%' "

  defp order_by_query(_field, nil = _order), do: ""
  defp order_by_query(field, order), do: "ORDER BY c.#{field} #{order} "

  defp handle_user_deactivation({:error, changeset}), do: {:error, changeset}
  defp handle_user_deactivation({:ok, camera}) do
    if get_enabled_user_cameras(camera.user_id) == [] do
      Users.disable_one(camera.user_id)
    end

    {:ok, camera}
  end
end
