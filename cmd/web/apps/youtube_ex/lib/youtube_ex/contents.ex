defmodule YoutubeEx.Contents do
  @moduledoc """
  The Contents context.
  """

  import Ecto.Query, warn: false
  alias YoutubeEx.Repo

  alias YoutubeEx.Contents.Video

  def list_videos do
    Repo.all(Video)
  end

  def get_video!(id), do: Repo.get!(Video, id)

  def create_video(attrs \\ %{}) do
    %Video{}
    |> Video.changeset(attrs)
    |> Repo.insert()
  end

  def update_video(%Video{} = video, attrs) do
    video
    |> Video.changeset(attrs)
    |> Repo.update()
  end

  def delete_video(%Video{} = video) do
    Repo.delete(video)
  end

  alias YoutubeEx.Contents.VideoFormat

  def list_video_formats do
    Repo.all(VideoFormat)
  end

  def get_video_format!(id), do: Repo.get!(VideoFormat, id)

  def create_video_format(attrs \\ %{}) do
    %VideoFormat{}
    |> VideoFormat.changeset(attrs)
    |> Repo.insert()
  end

  def update_video_format(%VideoFormat{} = video_format, attrs) do
    video_format
    |> VideoFormat.changeset(attrs)
    |> Repo.update()
  end

  def delete_video_format(%VideoFormat{} = video_format) do
    Repo.delete(video_format)
  end

  def list_user_videos(id) do
    query = from v in Video,
      where: v.user == ^id

    Repo.all(query)
  end
end
