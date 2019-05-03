defmodule YoutubeEx.ContentsTest do
  use YoutubeEx.DataCase

  alias YoutubeEx.Contents

  describe "videos" do
    alias YoutubeEx.Contents.Video

    @valid_attrs %{enabled: true, format: %{}, source: "some source", view: 42}
    @update_attrs %{enabled: false, format: %{}, source: "some updated source", view: 43}
    @invalid_attrs %{enabled: nil, format: nil, source: nil, view: nil}

    def video_fixture(attrs \\ %{}) do
      {:ok, video} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Contents.create_video()

      video
    end

    test "list_videos/0 returns all videos" do
      video = video_fixture()
      assert Contents.list_videos() == [video]
    end

    test "get_video!/1 returns the video with given id" do
      video = video_fixture()
      assert Contents.get_video!(video.id) == video
    end

    test "create_video/1 with valid data creates a video" do
      assert {:ok, %Video{} = video} = Contents.create_video(@valid_attrs)
      assert video.enabled == true
      assert video.format == %{}
      assert video.source == "some source"
      assert video.view == 42
    end

    test "create_video/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contents.create_video(@invalid_attrs)
    end

    test "update_video/2 with valid data updates the video" do
      video = video_fixture()
      assert {:ok, %Video{} = video} = Contents.update_video(video, @update_attrs)
      assert video.enabled == false
      assert video.format == %{}
      assert video.source == "some updated source"
      assert video.view == 43
    end

    test "update_video/2 with invalid data returns error changeset" do
      video = video_fixture()
      assert {:error, %Ecto.Changeset{}} = Contents.update_video(video, @invalid_attrs)
      assert video == Contents.get_video!(video.id)
    end

    test "delete_video/1 deletes the video" do
      video = video_fixture()
      assert {:ok, %Video{}} = Contents.delete_video(video)
      assert_raise Ecto.NoResultsError, fn -> Contents.get_video!(video.id) end
    end

    test "change_video/1 returns a video changeset" do
      video = video_fixture()
      assert %Ecto.Changeset{} = Contents.change_video(video)
    end
  end

  describe "videos" do
    alias YoutubeEx.Contents.Video

    @valid_attrs %{duration: 42, enabled: true, format: %{}, name: "some name", source: "some source", view: 42}
    @update_attrs %{duration: 43, enabled: false, format: %{}, name: "some updated name", source: "some updated source", view: 43}
    @invalid_attrs %{duration: nil, enabled: nil, format: nil, name: nil, source: nil, view: nil}

    def video_fixture(attrs \\ %{}) do
      {:ok, video} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Contents.create_video()

      video
    end

    test "list_videos/0 returns all videos" do
      video = video_fixture()
      assert Contents.list_videos() == [video]
    end

    test "get_video!/1 returns the video with given id" do
      video = video_fixture()
      assert Contents.get_video!(video.id) == video
    end

    test "create_video/1 with valid data creates a video" do
      assert {:ok, %Video{} = video} = Contents.create_video(@valid_attrs)
      assert video.duration == 42
      assert video.enabled == true
      assert video.format == %{}
      assert video.name == "some name"
      assert video.source == "some source"
      assert video.view == 42
    end

    test "create_video/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contents.create_video(@invalid_attrs)
    end

    test "update_video/2 with valid data updates the video" do
      video = video_fixture()
      assert {:ok, %Video{} = video} = Contents.update_video(video, @update_attrs)
      assert video.duration == 43
      assert video.enabled == false
      assert video.format == %{}
      assert video.name == "some updated name"
      assert video.source == "some updated source"
      assert video.view == 43
    end

    test "update_video/2 with invalid data returns error changeset" do
      video = video_fixture()
      assert {:error, %Ecto.Changeset{}} = Contents.update_video(video, @invalid_attrs)
      assert video == Contents.get_video!(video.id)
    end

    test "delete_video/1 deletes the video" do
      video = video_fixture()
      assert {:ok, %Video{}} = Contents.delete_video(video)
      assert_raise Ecto.NoResultsError, fn -> Contents.get_video!(video.id) end
    end

    test "change_video/1 returns a video changeset" do
      video = video_fixture()
      assert %Ecto.Changeset{} = Contents.change_video(video)
    end
  end

  describe "video_formats" do
    alias YoutubeEx.Contents.VideoFormat

    @valid_attrs %{code: "some code", uri: "some uri"}
    @update_attrs %{code: "some updated code", uri: "some updated uri"}
    @invalid_attrs %{code: nil, uri: nil}

    def video_format_fixture(attrs \\ %{}) do
      {:ok, video_format} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Contents.create_video_format()

      video_format
    end

    test "list_video_formats/0 returns all video_formats" do
      video_format = video_format_fixture()
      assert Contents.list_video_formats() == [video_format]
    end

    test "get_video_format!/1 returns the video_format with given id" do
      video_format = video_format_fixture()
      assert Contents.get_video_format!(video_format.id) == video_format
    end

    test "create_video_format/1 with valid data creates a video_format" do
      assert {:ok, %VideoFormat{} = video_format} = Contents.create_video_format(@valid_attrs)
      assert video_format.code == "some code"
      assert video_format.uri == "some uri"
    end

    test "create_video_format/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contents.create_video_format(@invalid_attrs)
    end

    test "update_video_format/2 with valid data updates the video_format" do
      video_format = video_format_fixture()
      assert {:ok, %VideoFormat{} = video_format} = Contents.update_video_format(video_format, @update_attrs)
      assert video_format.code == "some updated code"
      assert video_format.uri == "some updated uri"
    end

    test "update_video_format/2 with invalid data returns error changeset" do
      video_format = video_format_fixture()
      assert {:error, %Ecto.Changeset{}} = Contents.update_video_format(video_format, @invalid_attrs)
      assert video_format == Contents.get_video_format!(video_format.id)
    end

    test "delete_video_format/1 deletes the video_format" do
      video_format = video_format_fixture()
      assert {:ok, %VideoFormat{}} = Contents.delete_video_format(video_format)
      assert_raise Ecto.NoResultsError, fn -> Contents.get_video_format!(video_format.id) end
    end

    test "change_video_format/1 returns a video_format changeset" do
      video_format = video_format_fixture()
      assert %Ecto.Changeset{} = Contents.change_video_format(video_format)
    end
  end
end
