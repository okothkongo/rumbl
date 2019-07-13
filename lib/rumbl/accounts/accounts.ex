defmodule Rumbl.Accounts do
  alias Rumbl.Accounts.User
  alias Rumbl.Repo

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def list_users do
    User
    |> Repo.all()
  end
end
