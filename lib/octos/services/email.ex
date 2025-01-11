defmodule Octos.Services.Email do
  import Swoosh.Email

  def send_email_to_user(user, email_data) do
    subject = Map.get(email_data, "subject", "Notification from Octos")

    email_data
    |> Map.get("body", "")
    |> String.trim()
    |> send(subject, user.name, user.email)
  end

  defp send("" = _body, _subject, _name, _email), do: %Swoosh.Email{}
  defp send(body, subject, name, email) do
    formatted_body = "Hello #{name},\n\n" <> body <> "\n\nBest,\nOctos Team"

    new()
    |> to({name, email})
    |> from({"Octos", "noreply@octos.com"})
    |> subject(subject)
    |> text_body(formatted_body)
  end
end
