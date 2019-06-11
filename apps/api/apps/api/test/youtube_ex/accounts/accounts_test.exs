defmodule Api.AccountsTest do
  use Api.DataCase

  alias Api.Accounts

  describe "users" do
    alias Api.Accounts.User

    @valid_attrs %{email: "some email", pseudo: "some pseudo", username: "some username"}
    @update_attrs %{email: "some updated email", pseudo: "some updated pseudo", username: "some updated username"}
    @invalid_attrs %{email: nil, pseudo: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.pseudo == "some pseudo"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.email == "some updated email"
      assert user.pseudo == "some updated pseudo"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "credentials" do
    alias Api.Accounts.Credential

    @valid_attrs %{password: "some password"}
    @update_attrs %{password: "some updated password"}
    @invalid_attrs %{password: nil}

    def credential_fixture(attrs \\ %{}) do
      {:ok, credential} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_credential()

      credential
    end

    test "list_credentials/0 returns all credentials" do
      credential = credential_fixture()
      assert Accounts.list_credentials() == [credential]
    end

    test "get_credential!/1 returns the credential with given id" do
      credential = credential_fixture()
      assert Accounts.get_credential!(credential.id) == credential
    end

    test "create_credential/1 with valid data creates a credential" do
      assert {:ok, %Credential{} = credential} = Accounts.create_credential(@valid_attrs)
      assert credential.password == "some password"
    end

    test "create_credential/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_credential(@invalid_attrs)
    end

    test "update_credential/2 with valid data updates the credential" do
      credential = credential_fixture()
      assert {:ok, %Credential{} = credential} = Accounts.update_credential(credential, @update_attrs)
      assert credential.password == "some updated password"
    end

    test "update_credential/2 with invalid data returns error changeset" do
      credential = credential_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_credential(credential, @invalid_attrs)
      assert credential == Accounts.get_credential!(credential.id)
    end

    test "delete_credential/1 deletes the credential" do
      credential = credential_fixture()
      assert {:ok, %Credential{}} = Accounts.delete_credential(credential)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_credential!(credential.id) end
    end

    test "change_credential/1 returns a credential changeset" do
      credential = credential_fixture()
      assert %Ecto.Changeset{} = Accounts.change_credential(credential)
    end
  end

  describe "autorisations" do
    alias Api.Accounts.Autorisation

    @valid_attrs %{comment_video: true, create_video: true, create_video_format: true, delete_user: true, delete_video: true, update_user: true, update_video: true}
    @update_attrs %{comment_video: false, create_video: false, create_video_format: false, delete_user: false, delete_video: false, update_user: false, update_video: false}
    @invalid_attrs %{comment_video: nil, create_video: nil, create_video_format: nil, delete_user: nil, delete_video: nil, update_user: nil, update_video: nil}

    def autorisation_fixture(attrs \\ %{}) do
      {:ok, autorisation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_autorisation()

      autorisation
    end

    test "list_autorisations/0 returns all autorisations" do
      autorisation = autorisation_fixture()
      assert Accounts.list_autorisations() == [autorisation]
    end

    test "get_autorisation!/1 returns the autorisation with given id" do
      autorisation = autorisation_fixture()
      assert Accounts.get_autorisation!(autorisation.id) == autorisation
    end

    test "create_autorisation/1 with valid data creates a autorisation" do
      assert {:ok, %Autorisation{} = autorisation} = Accounts.create_autorisation(@valid_attrs)
      assert autorisation.comment_video == true
      assert autorisation.create_video == true
      assert autorisation.create_video_format == true
      assert autorisation.delete_user == true
      assert autorisation.delete_video == true
      assert autorisation.update_user == true
      assert autorisation.update_video == true
    end

    test "create_autorisation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_autorisation(@invalid_attrs)
    end

    test "update_autorisation/2 with valid data updates the autorisation" do
      autorisation = autorisation_fixture()
      assert {:ok, %Autorisation{} = autorisation} = Accounts.update_autorisation(autorisation, @update_attrs)
      assert autorisation.comment_video == false
      assert autorisation.create_video == false
      assert autorisation.create_video_format == false
      assert autorisation.delete_user == false
      assert autorisation.delete_video == false
      assert autorisation.update_user == false
      assert autorisation.update_video == false
    end

    test "update_autorisation/2 with invalid data returns error changeset" do
      autorisation = autorisation_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_autorisation(autorisation, @invalid_attrs)
      assert autorisation == Accounts.get_autorisation!(autorisation.id)
    end

    test "delete_autorisation/1 deletes the autorisation" do
      autorisation = autorisation_fixture()
      assert {:ok, %Autorisation{}} = Accounts.delete_autorisation(autorisation)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_autorisation!(autorisation.id) end
    end

    test "change_autorisation/1 returns a autorisation changeset" do
      autorisation = autorisation_fixture()
      assert %Ecto.Changeset{} = Accounts.change_autorisation(autorisation)
    end
  end

  describe "autorisations" do
    alias Api.Accounts.Autorisation

    @valid_attrs %{arsdelete_user: true, comment_video: true, create_video: true, create_video_format: true, delete_video: true, update_user: true, update_video: true}
    @update_attrs %{arsdelete_user: false, comment_video: false, create_video: false, create_video_format: false, delete_video: false, update_user: false, update_video: false}
    @invalid_attrs %{arsdelete_user: nil, comment_video: nil, create_video: nil, create_video_format: nil, delete_video: nil, update_user: nil, update_video: nil}

    def autorisation_fixture(attrs \\ %{}) do
      {:ok, autorisation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_autorisation()

      autorisation
    end

    test "list_autorisations/0 returns all autorisations" do
      autorisation = autorisation_fixture()
      assert Accounts.list_autorisations() == [autorisation]
    end

    test "get_autorisation!/1 returns the autorisation with given id" do
      autorisation = autorisation_fixture()
      assert Accounts.get_autorisation!(autorisation.id) == autorisation
    end

    test "create_autorisation/1 with valid data creates a autorisation" do
      assert {:ok, %Autorisation{} = autorisation} = Accounts.create_autorisation(@valid_attrs)
      assert autorisation.arsdelete_user == true
      assert autorisation.comment_video == true
      assert autorisation.create_video == true
      assert autorisation.create_video_format == true
      assert autorisation.delete_video == true
      assert autorisation.update_user == true
      assert autorisation.update_video == true
    end

    test "create_autorisation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_autorisation(@invalid_attrs)
    end

    test "update_autorisation/2 with valid data updates the autorisation" do
      autorisation = autorisation_fixture()
      assert {:ok, %Autorisation{} = autorisation} = Accounts.update_autorisation(autorisation, @update_attrs)
      assert autorisation.arsdelete_user == false
      assert autorisation.comment_video == false
      assert autorisation.create_video == false
      assert autorisation.create_video_format == false
      assert autorisation.delete_video == false
      assert autorisation.update_user == false
      assert autorisation.update_video == false
    end

    test "update_autorisation/2 with invalid data returns error changeset" do
      autorisation = autorisation_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_autorisation(autorisation, @invalid_attrs)
      assert autorisation == Accounts.get_autorisation!(autorisation.id)
    end

    test "delete_autorisation/1 deletes the autorisation" do
      autorisation = autorisation_fixture()
      assert {:ok, %Autorisation{}} = Accounts.delete_autorisation(autorisation)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_autorisation!(autorisation.id) end
    end

    test "change_autorisation/1 returns a autorisation changeset" do
      autorisation = autorisation_fixture()
      assert %Ecto.Changeset{} = Accounts.change_autorisation(autorisation)
    end
  end
end
