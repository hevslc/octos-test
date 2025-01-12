defmodule Octos.Services.EmailTest do
  use Octos.DataCase
  import Mock
  alias Octos.Mailer
  alias Octos.Models.User
  alias Octos.Services.Email

  describe "send_email_to_users/2" do
    test "sends an email with the email data" do
      with_mocks [
        {Mailer, [:passthrough], [deliver: fn _email -> :ok end]}
      ] do
        user = %User{name: "Hevelyn Carvalho", email: "hc.doe@example.com"}
        email_data = %{
          "subject" => "Welcome to Octos",
          "body" => "Thank you for joining our team!"
        }
        expected_email_body = parse_body(user.name, email_data["body"])
        expected_email = swooah_email(email_data["subject"], user.name, user.email, expected_email_body)

        Email.send_email_to_users([user], email_data)

        assert_called Mailer.deliver(expected_email)
      end
    end

    test "uses default subject when not provided" do
      with_mocks [
        {Mailer, [:passthrough], [deliver: fn _email -> :ok end]}
      ] do
        user = %User{name: "Cody Maverick", email: "cm@example.com"}
        email_data = %{
          "body" => "Important update for you."
        }
        expected_email_body = parse_body(user.name, email_data["body"])
        expected_email = swooah_email("Notification from Octos", user.name, user.email, expected_email_body)

        Email.send_email_to_users([user], email_data)

        assert_called Mailer.deliver(expected_email)
      end
    end

    test "return empty object when email data not provided" do
      with_mocks [
        {Mailer, [:passthrough], [deliver: fn _email -> :ok end]}
      ] do
        user = %User{name: "Zeke", email: "zeke@example.com"}
        email_data = %{"body" => ""}

        Email.send_email_to_users([user], email_data)

        assert_not_called Mailer.deliver(empty_email())
      end
    end
  end

  defp parse_body(name, body) do
    "Hello #{name},\n\n" <> body <> "\n\nBest,\nOctos Team"
  end

  defp swooah_email(subject, user_name, user_email, text_body) do
    %Swoosh.Email{
      subject: subject,
      from: {"Octos", "noreply@octos.com"},
      to: [{user_name, user_email}],
      cc: [],
      bcc: [],
      text_body: text_body,
      html_body: nil,
      attachments: [],
      reply_to: nil,
      headers: %{},
      private: %{},
      assigns: %{},
      provider_options: %{}
    }
  end

  defp empty_email do
    %Swoosh.Email{
      subject: "",
      from: nil,
      to: [],
      cc: [],
      bcc: [],
      text_body: nil,
      html_body: nil,
      attachments: [],
      reply_to: nil,
      headers: %{},
      private: %{},
      assigns: %{},
      provider_options: %{}
    }
  end
end
