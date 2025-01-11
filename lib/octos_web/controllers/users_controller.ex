defmodule OctosWeb.UsersController do
  use OctosWeb, :controller
  alias Octos.Services.Users
  alias OctosWeb.ErrorView

  def create(conn, params) do
    with {:ok, user} <- Users.create(params) do
      conn
      |> put_status(:created)
      |> render("create.json", user: user)
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:bad_request)
        |> put_view(ErrorView)
        |> render("error.json", changeset: changeset)
    end
  end

  def notify_users(conn, _params) do
    # This is where the notification logic will go
    conn
    |> put_status(:ok)
    |> render("notify_users.json")
  end
end
