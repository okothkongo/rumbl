defmodule RumblWeb.UserController do
  use RumblWeb, :controller
  alias Rumbl.Accounts
  alias Rumbl.Accounts.User

  def new(conn, _parmas) do
    changeset = User.changeset(%User{}, %{})

    conn
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"user" => params}) do
    with {:ok, _user} <- Accounts.create_user(params) do
      conn
      |> put_flash(:info, "User created Successfully")
      |> redirect(to: Routes.page_path(conn, :index))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "User not created")
        |> render("new.html", changeset: changeset)
    end
  end
end
