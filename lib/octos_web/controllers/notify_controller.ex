defmodule OctosWeb.NotifyController do
  use OctosWeb, :controller

  alias Octos.Mailer
  alias Octos.Services.Email
  alias Octos.Services.Users.Queries, as: Users

  @doc """
  Notify users based on filters, sending an email with the given email_data
  filter type:
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
  email_data type:
    %{
      "subject" => "Notification from Octos",
      "body" => "Email Body"
    }
  """
  def notify_users(conn, %{"filters" => filters, "email_data" => email_data}) do
    users = Users.fetch_users_by(filters)

    for user <- users do
      user
      |> Email.send_email_to_user(email_data)
      |> Mailer.deliver()
    end

    send_resp(conn, :no_content, "")
  end

  def notify_users(conn, _), do: send_resp(conn, :no_content, "")
end
