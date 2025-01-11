defmodule OctosWeb.CamerasJSON do
  def render("users_cameras.json", %{users_cameras: users_cameras}) do
    %{
      enabled_users:
        users_cameras
        |> Enum.filter(fn user -> user.enabled end)
        |> Enum.map(fn user -> %{user: user.name, cameras: user.cameras} end),
      disabled_users:
        users_cameras
        |> Enum.filter(fn user -> user.enabled == false end)
        |> Enum.map(fn user -> %{user: user.name, disabled_date: user.updated_at} end)
    }
  end
end
