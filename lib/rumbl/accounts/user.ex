defmodule Rumbl.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :username, :string
    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username])
    |> validate_required([:username, :name])
    |> validate_length(:username, min: 1, max: 20)
    |> unique_constraint(:username, message: "User name already exists")
  end
end
