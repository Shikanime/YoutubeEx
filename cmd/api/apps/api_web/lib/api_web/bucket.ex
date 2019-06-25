defmodule Api.Web.Bucket do
  @video_formats ["1080", "720", "480", "360", "240", "120"]
  @video_extensions [".mp4", ".avi"]

  def store_video(video_namespace, video_name, video, opts \\ []) do
    with {:ok, format} <- fetch_video_format(opts),
         {:ok, ext} <- fetch_video_extension(video) do
      priv_dir = Application.app_dir(:api_web, "priv")
      static_dir = "#{priv_dir}/static"

      video_dir = "videos/#{video_namespace}/#{video_name}"
      video_uri = "#{video_dir}/#{format}#{ext}"

      static_video_dir = "#{static_dir}/#{video_dir}"
      static_video_file = "#{static_dir}/#{video_dir}/#{format}#{ext}"

      with :ok <- File.mkdir_p(static_video_dir),
           :ok <- File.cp(video.path, static_video_file),
           do: {:ok, video_uri}
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
