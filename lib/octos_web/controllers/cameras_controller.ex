defmodule OctosWeb.CamerasController do
  use OctosWeb, :controller
  alias Octos.Services.Cameras.Queries, as: Cameras

  def users_cameras(conn, params) do
    users_cameras = Cameras.fetch_users_cameras(params)

    conn
    |> put_status(:ok)
    |> render("users_cameras.json", users_cameras: users_cameras)
  end
end
