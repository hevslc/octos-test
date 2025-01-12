defmodule OctosWeb.CamerasController do
  use OctosWeb, :controller
  alias Octos.Services.Cameras.Queries, as: Cameras

  @doc """
  List enabled cameras for users
  param is of type:
    {
      "filter": substring_to_filter_cameras # is optional
      "order": "asc" | "desc" # is optional
    }
  """
  def users_cameras(conn, params) do
    users_cameras = Cameras.fetch_users_cameras(params)

    conn
    |> put_status(:ok)
    |> render("users_cameras.json", users_cameras: users_cameras)
  end
end
