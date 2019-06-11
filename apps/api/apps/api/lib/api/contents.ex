defmodule Api.Contents do
  @moduledoc """
  The Contents context.
  """

  import Ecto.Query, warn: false
  alias Api.Repo

  alias Api.Contents.Video

  def paginate_videos(opts \\ []) do
    Video
    |> paginated_videos(opts)
  end

  def paginate_user_videos(id, opts \\ []) do
    Video
    |> where(user_id: ^id)
    |> paginated_videos(opts)
  end

  def get_video!(id) do
    Video
    |> where(id: ^id)
    |> preload(:formats)
    |> Repo.one!()
  end

  def create_video(attrs \\ %{}) do
    Repo.transaction(fn ->
      video =
        %Video{}
        |> Video.create_changeset(attrs)
        |> Repo.insert!()

      get_video!(video.id)
    end)
  rescue
    e in Ecto.InvalidChangesetError ->
      {:error, e.changeset}

    other ->
      {:error, other}
  end

  def update_video(%Video{} = video, attrs) do
    video
    |> Video.update_changeset(attrs)
    |> Repo.update()
  end

  def delete_video(%Video{} = video) do
    Repo.delete(video)
  end

  defp paginated_videos(query, opts) do
    opts = Keyword.new(opts, fn
      {:index, x}  -> {:page, x}
      {:offset, x} -> {:page_size, x}
      other -> other
    end)

    query
    |> preload(:formats)
    |> Repo.paginate(opts)
  end

  alias Api.Contents.VideoFormat

  def create_video_format(video_id, attrs \\ %{}) do
    attrs = Map.put(attrs, "video_id", video_id)

    Repo.transaction(fn ->
      video = get_video!(video_id)

      video
      |> Ecto.build_assoc(:formats)
      |> VideoFormat.changeset(attrs)
      |> Repo.insert!()

      video
    end)
  rescue
    e in Ecto.InvalidChangesetError ->
      {:error, e.changeset}

    other ->
      {:error, other}
  end
end
