defmodule Octos.Services.EmailTest do
  use ExUnit.Case
  alias Octos.Services.Email
  alias Octos.Models.User

  describe "send_email_to_user/2" do
    test "sends an email with the email data" do
      user = %User{name: "Hevelyn Carvalho", email: "hc.doe@example.com"}
      email_data = %{
        "subject" => "Welcome to Octos",
        "body" => "Thank you for joining our team!"
      }

      email = Email.send_email_to_user(user, email_data)

      assert email.subject == "Welcome to Octos"
      assert email.text_body == parse_body(user.name, email_data["body"])
    end

    test "uses default subject when not provided" do
      user = %User{name: "Cody Maverick", email: "cm@example.com"}
      email_data = %{
        "body" => "Important update for you."
      }

      email = Email.send_email_to_user(user, email_data)

      assert email.subject == "Notification from Octos"
      assert email.text_body == parse_body(user.name, email_data["body"])
    end

    test "return empty object when email data not provided" do
      user = %User{name: "Zeke", email: "zeke@example.com"}
      email_data = %{"body" => ""}

      assert Email.send_email_to_user(user, email_data) == %Swoosh.Email{}
    end
  end

  defp parse_body(name, body) do
    "Hello #{name},\n\n" <> body <> "\n\nBest,\nOctos Team"
  end
end
