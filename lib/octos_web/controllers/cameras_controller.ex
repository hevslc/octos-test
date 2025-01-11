defmodule OctosWeb.CamerasController do
  use OctosWeb, :controller
  alias Octos.Services.Cameras

  def users_cameras(conn, params) do
    filter = Map.get(params, "filter")
    sort = Map.get(params, "sort")
    users_cameras = Cameras.get_users_cameras(filter, sort)

    conn
    |> put_status(:ok)
    |> render("users_cameras.json", users_cameras: users_cameras)
  end
end
