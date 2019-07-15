defmodule RumblWeb.UserController do
  use RumblWeb, :controller
  alias Rumbl.Accounts
  alias Rumbl.Accounts.User
  alias RumblWeb.Auth
  plug :authenticate when action in [:index, :show]

  def new(conn, _params) do
    changeset = User.changeset(%User{}, %{})

    conn
    |> render("new.html", changeset: changeset)
  end

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def create(conn, %{"user" => params}) do
    with {:ok, user} <- Accounts.register_user(params) do
      conn
      |> Auth.login(user)
      |> put_flash(:info, "#{user.username} was successfully registered")
      |> redirect(to: Routes.user_path(conn, :index))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "User not created")
        |> render("new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user(id)

    conn
    |> render("show.html", user: user)
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end
end
