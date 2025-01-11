defmodule OctosWeb.UsersView do
  use OctosWeb, :view

  alias Octos.User

  def render("create.json", %{user: %User{} = user}) do
    %{
      message: "User created!",
      user: user
    }
  end

  def render("show_users_cameras.json", %{users: users}) do
    users
  end
end
