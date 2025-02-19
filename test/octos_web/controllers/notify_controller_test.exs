defmodule OctosWeb.NotifyControllerTest do
  use OctosWeb.ConnCase
  import Mock
  alias Octos.Services.Email
  alias Octos.Services.Users.Queries, as: Users

  @users_mock [%{name: "Dr. Henry Wu", email: "dr.hw@example.com"}]

  describe "POST /notify-users" do
    test "sends email to users based on filters", %{conn: conn} do
      with_mocks [
        {Users, [:passthrough], [fetch_users_by: fn _filters -> @users_mock end]},
        {Email, [:passthrough], [send_email_to_users: fn _user, _email_data -> :ok end]},
      ] do
        filters = %{
          "user" => %{"name" => ["Dr. Henry Wu"]},
          "camera" => %{"brand" => ["Hikvision"]}
        }

        email_data = %{
          "subject" => "Notification from Octos",
          "body" => "Email Body"
        }

        conn = post(conn, "/api/notify-users", %{"filters" => filters, "email_data" => email_data})

        assert response(conn, 204)
        assert_called Email.send_email_to_users([%{name: "Dr. Henry Wu", email: "dr.hw@example.com"}], email_data)
      end
    end
  end
end
