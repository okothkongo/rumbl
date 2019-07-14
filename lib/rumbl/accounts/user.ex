defmodule Rumbl.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rumbl.Accounts.Credential

  schema "users" do
    field :name, :string
    field :username, :string
    has_one :credential, Credential
    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username])
    |> validate_required([:username, :name])
    |> validate_length(:username, min: 1, max: 20)
    |> unique_constraint(:username, message: "User name already exists")
  end

  def registration_changeset(user, attrs) do
    user
    |> changeset(attrs)
    |> cast_assoc(:credential, with: &Credential.changeset/2, required: true)
  end
end
