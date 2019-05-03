defmodule YoutubeEx.Contents do
  @moduledoc """
  The Contents context.
  """

  import Ecto.Query, warn: false
  alias YoutubeEx.Repo

  alias YoutubeEx.Contents.Video

  @doc """
  Returns the list of videos.

  ## Examples

      iex> list_videos()
      [%Video{}, ...]

  """
  def list_videos do
    Repo.all(Video)
  end

  @doc """
  Gets a single video.

  Raises `Ecto.NoResultsError` if the Video does not exist.

  ## Examples

      iex> get_video!(123)
      %Video{}

      iex> get_video!(456)
      ** (Ecto.NoResultsError)

  """
  def get_video!(id), do: Repo.get!(Video, id)

  @doc """
  Creates a video.

  ## Examples

      iex> create_video(%{field: value})
      {:ok, %Video{}}

      iex> create_video(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_video(attrs \\ %{}) do
    %Video{}
    |> Video.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a video.

  ## Examples

      iex> update_video(video, %{field: new_value})
      {:ok, %Video{}}

      iex> update_video(video, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_video(%Video{} = video, attrs) do
    video
    |> Video.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Video.

  ## Examples

      iex> delete_video(video)
      {:ok, %Video{}}

      iex> delete_video(video)
      {:error, %Ecto.Changeset{}}

  """
  def delete_video(%Video{} = video) do
    Repo.delete(video)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking video changes.

  ## Examples

      iex> change_video(video)
      %Ecto.Changeset{source: %Video{}}

  """
  def change_video(%Video{} = video) do
    Video.changeset(video, %{})
  end

  alias YoutubeEx.Contents.VideoFormat

  @doc """
  Returns the list of video_formats.

  ## Examples

      iex> list_video_formats()
      [%VideoFormat{}, ...]

  """
  def list_video_formats do
    Repo.all(VideoFormat)
  end

  @doc """
  Gets a single video_format.

  Raises `Ecto.NoResultsError` if the Video format does not exist.

  ## Examples

      iex> get_video_format!(123)
      %VideoFormat{}

      iex> get_video_format!(456)
      ** (Ecto.NoResultsError)

  """
  def get_video_format!(id), do: Repo.get!(VideoFormat, id)

  @doc """
  Creates a video_format.

  ## Examples

      iex> create_video_format(%{field: value})
      {:ok, %VideoFormat{}}

      iex> create_video_format(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_video_format(attrs \\ %{}) do
    %VideoFormat{}
    |> VideoFormat.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a video_format.

  ## Examples

      iex> update_video_format(video_format, %{field: new_value})
      {:ok, %VideoFormat{}}

      iex> update_video_format(video_format, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_video_format(%VideoFormat{} = video_format, attrs) do
    video_format
    |> VideoFormat.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a VideoFormat.

  ## Examples

      iex> delete_video_format(video_format)
      {:ok, %VideoFormat{}}

      iex> delete_video_format(video_format)
      {:error, %Ecto.Changeset{}}

  """
  def delete_video_format(%VideoFormat{} = video_format) do
    Repo.delete(video_format)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking video_format changes.

  ## Examples

      iex> change_video_format(video_format)
      %Ecto.Changeset{source: %VideoFormat{}}

  """
  def change_video_format(%VideoFormat{} = video_format) do
    VideoFormat.changeset(video_format, %{})
  end
end
