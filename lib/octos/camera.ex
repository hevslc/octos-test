defmodule Octos.Camera do
  use Ecto.Schema
  import Ecto.Changeset
  alias Octos.User

  @derive {Jason.Encoder, only: [:id, :name, :brand, :enabled]}

  schema "cameras" do
    field :name,                :string
    field :brand,               :string
    field :enabled,             :boolean, default: true

    belongs_to :user, User

    timestamps()
  end

  def changeset(%{} = params) do
    %__MODULE__{}
    |> cast(params, [:name, :brand, :enabled])
    |> validate_required([:name, :brand, :user_id])
  end
end
