defmodule Octos.Models.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Octos.Models.Camera

  @derive {Jason.Encoder, only: [:id, :name, :email, :enabled, :cameras]}

  schema "users" do
    field :name, :string
    field :email, :string
    field :encrypted_password, :string
    field :enabled, :boolean, default: true

    has_many :cameras, Camera

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, [:name, :email, :encrypted_password, :enabled])
    |> validate_required([:name, :email])
  end
end
