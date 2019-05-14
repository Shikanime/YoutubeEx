defmodule YoutubeExApi.Bucket do
  @video_formats ["1080", "720", "480", "360", "240", "120"]
  @video_extensions [".mp4", ".avi"]

  def store_video(namespace, video, opts \\ []) do
    with {:ok, format} <- fetch_video_format(opts),
         {:ok, ext} <- fetch_video_extension(video) do
      priv_dir = Application.app_dir(:youtube_ex_api, "priv")
      video_file_name = Path.basename(video.filename, ext)
      video_dir = "#{priv_dir}/static/videos/#{namespace}/#{video_file_name}"
      video_path = "#{video_dir}/#{format}#{ext}"

      with :ok <- File.mkdir_p(video_dir),
            :ok <- File.cp(video.path, video_path),
            do: {:ok, video_path}
    end
  end

  defp fetch_video_extension(video) do
    ext = Path.extname(video.filename)
    with :ok <- verify_video_extension(ext),
      do: {:ok, ext}
  end

  defp fetch_video_format(opts) do
    case Keyword.get(opts, :format) do
      nil ->
        {:ok, "source"}

      format ->
        with :ok <- verify_video_format(format),
         do: {:ok, format}
    end
  end

  defp verify_video_extension(ext) when ext in @video_extensions,
    do: :ok
  defp verify_video_extension(_),
    do: {:error, :bad_extension}

  def verify_video_format(format) when format in @video_formats,
    do: :ok
  def verify_video_format(_),
    do: {:error, :unsupported_format}
end
