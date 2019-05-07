defmodule YoutubeExApi.AutorisationControllerTest do
  use YoutubeExApi.ConnCase

  alias YoutubeEx.Accounts
  alias YoutubeEx.Accounts.Autorisation

  @create_attrs %{
    comment_video: true,
    create_video: true,
    create_video_format: true,
    delete_user: true,
    delete_video: true,
    update_user: true,
    update_video: true
  }
  @update_attrs %{
    comment_video: false,
    create_video: false,
    create_video_format: false,
    delete_user: false,
    delete_video: false,
    update_user: false,
    update_video: false
  }
  @invalid_attrs %{comment_video: nil, create_video: nil, create_video_format: nil, delete_user: nil, delete_video: nil, update_user: nil, update_video: nil}

  def fixture(:autorisation) do
    {:ok, autorisation} = Accounts.create_autorisation(@create_attrs)
    autorisation
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all autorisations", %{conn: conn} do
      conn = get(conn, Routes.autorisation_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create autorisation" do
    test "renders autorisation when data is valid", %{conn: conn} do
      conn = post(conn, Routes.autorisation_path(conn, :create), autorisation: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.autorisation_path(conn, :show, id))

      assert %{
               "id" => id,
               "comment_video" => true,
               "create_video" => true,
               "create_video_format" => true,
               "delete_user" => true,
               "delete_video" => true,
               "update_user" => true,
               "update_video" => true
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.autorisation_path(conn, :create), autorisation: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update autorisation" do
    setup [:create_autorisation]

    test "renders autorisation when data is valid", %{conn: conn, autorisation: %Autorisation{id: id} = autorisation} do
      conn = put(conn, Routes.autorisation_path(conn, :update, autorisation), autorisation: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.autorisation_path(conn, :show, id))

      assert %{
               "id" => id,
               "comment_video" => false,
               "create_video" => false,
               "create_video_format" => false,
               "delete_user" => false,
               "delete_video" => false,
               "update_user" => false,
               "update_video" => false
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, autorisation: autorisation} do
      conn = put(conn, Routes.autorisation_path(conn, :update, autorisation), autorisation: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete autorisation" do
    setup [:create_autorisation]

    test "deletes chosen autorisation", %{conn: conn, autorisation: autorisation} do
      conn = delete(conn, Routes.autorisation_path(conn, :delete, autorisation))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.autorisation_path(conn, :show, autorisation))
      end
    end
  end

  defp create_autorisation(_) do
    autorisation = fixture(:autorisation)
    {:ok, autorisation: autorisation}
  end
end
