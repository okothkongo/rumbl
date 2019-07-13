defmodule Rumbl.UserTests do
  @moduledoc """
  This module contains tests for user accounts.
  """
  use Rumbl.DataCase
  alias Rumbl.Accounts

  setup do
    valid_attrs = %{
      username: "okoth",
      name: "kongo"
    }

    invalid_attrs = %{username: nil}
    [valid_attrs: valid_attrs, invalid_attrs: invalid_attrs]
  end

  test "create_user/1 creates for valid user", %{valid_attrs: valid_attrs} do
    {:ok, user} = Accounts.create_user(valid_attrs)
    assert user.name == "kongo"
  end

  test "create_user/1 throws error for invalid attrs", %{invalid_attrs: invalid_attrs} do
    {:error, changeset} = Accounts.create_user(invalid_attrs)
    assert changeset.valid? == false
  end
end
