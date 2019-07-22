defmodule Rumbl.UserTests do
  @moduledoc """
  This module contains tests for user accounts.
  """
  use Rumbl.DataCase

  alias Rumbl.Accounts

  describe "User" do
    @valid_attrs %{
      name: "User",
      username: "eva",
      credential: %{email: "eva@test", password: "secret"}
    }
    @invalid_attrs %{}
    test "create_user/1 creates for valid user" do
      {:ok, user} = Accounts.create_user(@valid_attrs)
      assert user.name == "User"
    end

    test "create_user/1  do not insert user with invalid attrs" do
      {:error, changeset} = Accounts.create_user(@invalid_attrs)
      assert changeset.valid? == false
      assert Accounts.list_users() == []
    end

    test " register_user/2 with valid data inserts user" do
      assert {:ok, user} = Accounts.register_user(@valid_attrs)
      assert user.name == "User"
    end

    test "  register_user/2 with invalid data does not insert user" do
      assert {:error, changeset} = Accounts.register_user(@invalid_attrs)
      assert Accounts.list_users() == []
      assert changeset.valid? == false
    end

    test "  register_user/2  enforces unique usernames" do
      assert {:ok, _user} = Accounts.register_user(@valid_attrs)
      assert {:error, changeset} = Accounts.register_user(@valid_attrs)
      assert %{username: ["User name already exists"]} == errors_on(changeset)

      assert Accounts.list_users() |> Enum.count() == 1
    end

    test "  register_user/2  does not accept long usernames" do
      attrs = Map.put(@valid_attrs, :username, String.duplicate("a", 30))
      {:error, changeset} = Accounts.register_user(attrs)
      assert %{username: ["should be at most 20 character(s)"]} = errors_on(changeset)
      assert Accounts.list_users() == []
    end

    test "  register_user/2  requires password to be at least 6 chars long" do
      attrs = put_in(@valid_attrs, [:credential, :password], "12345")
      {:error, changeset} = Accounts.register_user(attrs)

      assert %{password: ["should be at least 6 character(s)"]} =
               errors_on(changeset)[:credential]

      assert Accounts.list_users() == []
    end

    test "get_user/1 fetches user with given id" do
      {:ok, %{id: id}} = Accounts.register_user(@valid_attrs)
      user = Accounts.get_user(id)
      assert user.name == "User"
    end
  end
end
