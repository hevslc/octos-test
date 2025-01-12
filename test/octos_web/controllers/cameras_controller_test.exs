defmodule OctosWeb.CamerasControllerTest do
  use OctosWeb.ConnCase
  import Mock
  alias Octos.Services.Cameras.Queries, as: Cameras

  @user_cameras_mock [
    %{
      name: "Cody Maverick",
      email: "cm@example.com",
      enabled: true,
      updated_at: ~N[2021-09-01 00:00:00],
      cameras: [
        %{"name" => "Camera 1", "brand" => "Brand A", "enabled" => true},
        %{"name" => "Camera 2", "brand" => "Brand B", "enabled" => true},
      ]
    },
    %{
      name: "Zeke",
      email: "zeke@example.com",
      enabled: false,
      updated_at: ~N[2021-09-01 00:00:00],
      cameras: []
    },
  ]

  describe "GET /users_cameras" do
    test "returns the list of cameras for the user", %{conn: conn} do
      with_mock Cameras, [fetch_users_cameras: fn _params -> @user_cameras_mock end] do

        conn = get(conn, "/api/cameras")
        resp = json_response(conn, 200)

        assert resp["enabled_users"] == [
          %{
            "cameras" => [
              %{"name" => "Camera 1", "brand" => "Brand A", "enabled" => true},
              %{"name" => "Camera 2", "brand" => "Brand B", "enabled" => true},
            ],
            "user" => "Cody Maverick",
          }
        ]

        assert resp["disabled_users"] == [
          %{
            "disabled_date" => "2021-09-01T00:00:00",
            "user" => "Zeke",
          }
        ]
      end
    end
  end
end
