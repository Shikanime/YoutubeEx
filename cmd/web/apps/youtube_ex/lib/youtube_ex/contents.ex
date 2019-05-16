defmodule YoutubeEx.Contents do
  @moduledoc """
  The Contents context.
  """

  import YoutubeEx.Repo.Helpers, warn: false
  import Ecto.Query, warn: false
  alias YoutubeEx.Repo

  alias YoutubeEx.Contents.Video

  def paginate_videos(opts \\ []) do
    Video
    |> with_paginated_videos(opts)
  end

  def paginate_user_videos(id, opts \\ []) do
    Video
    |> where(user_id: ^id)
    |> with_paginated_videos(opts)
  end

  def get_video!(id), do: Repo.get!(Video, id)

  def create_video(attrs \\ %{}) do
    Repo.transaction(fn ->
      video =
        %Video{}
        |> Video.create_changeset(attrs)
        |> Repo.insert!()

      Video
      |> where(id: ^video.id)
      |> preload(:formats)
      |> Repo.one()
    end)
  end

  def update_video(%Video{} = video, attrs) do
    video
    |> Video.update_changeset(attrs)
    |> Repo.update()
  end

  def delete_video(%Video{} = video) do
    Repo.delete(video)
  end

  defp with_paginated_videos(query, opts) do
    query
    |> preload(:formats)
    |> with_pagination(opts)
  end

  alias YoutubeEx.Contents.VideoFormat

  def create_video_format(video_id, attrs \\ %{}) do
    attrs = Map.put(attrs, "video_id", video_id)

    Repo.transaction(fn ->
      video =
        Video
        |> where(id: ^video_id)
        |> preload(:formats)
        |> Repo.one()

      video
      |> Ecto.build_assoc(:formats)
      |> VideoFormat.changeset(attrs)
      |> Repo.insert()

      video
    end)
  end
end
