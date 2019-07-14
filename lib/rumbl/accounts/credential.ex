defmodule Rumbl.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rumbl.Accounts.User

  schema "credentials" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
    |> validate_length(:password, min: 6, max: 100)
    |> unique_constraint(:email)
    |> _put_pass_hash()
  end

  defp _put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{pass: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Pbkdf2.hashpwsalt(pass))

      _ ->
        changeset
    end
  end
end
