defmodule Octos.Models.Camera do
  use Ecto.Schema
  import Ecto.Changeset
  alias Octos.Models.User

  @derive {Jason.Encoder, only: [:id, :name, :brand, :enabled]}

  schema "cameras" do
    field :name,                :string
    field :brand,               :string
    field :enabled,             :boolean, default: true

    belongs_to :user, User

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, [:name, :brand, :enabled, :user_id])
    |> validate_required([:name, :brand, :user_id])
    |> foreign_key_constraint(:user_id, message: "User must exist")
  end
end
