defmodule Octos.Services.Email do
  @moduledoc """
  This module contains functions to send emails to users.
  """
  import Swoosh.Email
  alias Octos.Mailer

  @doc """
  Sends an email to a user with the given data.
  email_data is a map with the following keys:
    - subject: the email subject # optional
    - body: the email body # optional (is required to send an email)
  """

  def send_email_to_user(users, email_data) when is_list(users) do
    for user <- users do
      user
      |> send_email_to_user(email_data)
      |> Mailer.deliver()
    end
  end

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
