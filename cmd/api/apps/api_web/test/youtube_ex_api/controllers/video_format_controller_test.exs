defmodule Api.Web.VideoFormatControllerTest do
  use Api.Web.ConnCase

  alias Api.Contents
  alias Api.Contents.VideoFormat

  @create_attrs %{
    code: "some code",
    uri: "some uri"
  }
  @update_attrs %{
    code: "some updated code",
    uri: "some updated uri"
  }
  @invalid_attrs %{code: nil, uri: nil}

  def fixture(:video_format) do
    {:ok, video_format} = Contents.create_video_format(@create_attrs)
    video_format
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all video_formats", %{conn: conn} do
      conn = get(conn, Routes.video_format_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create video_format" do
    test "renders video_format when data is valid", %{conn: conn} do
      conn = post(conn, Routes.video_format_path(conn, :create), video_format: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.video_format_path(conn, :show, id))

      assert %{
               "id" => id,
               "code" => "some code",
               "uri" => "some uri"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.video_format_path(conn, :create), video_format: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update video_format" do
    setup [:create_video_format]

    test "renders video_format when data is valid", %{
      conn: conn,
      video_format: %VideoFormat{id: id} = video_format
    } do
      conn =
        put(conn, Routes.video_format_path(conn, :update, video_format),
          video_format: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.video_format_path(conn, :show, id))

      assert %{
               "id" => id,
               "code" => "some updated code",
               "uri" => "some updated uri"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, video_format: video_format} do
      conn =
        put(conn, Routes.video_format_path(conn, :update, video_format),
          video_format: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete video_format" do
    setup [:create_video_format]

    test "deletes chosen video_format", %{conn: conn, video_format: video_format} do
      conn = delete(conn, Routes.video_format_path(conn, :delete, video_format))
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, Routes.video_format_path(conn, :show, video_format))
      end)
    end
  end

  defp create_video_format(_) do
    video_format = fixture(:video_format)
    {:ok, video_format: video_format}
  end
end
