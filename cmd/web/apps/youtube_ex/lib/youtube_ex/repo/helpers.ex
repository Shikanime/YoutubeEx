defmodule YoutubeEx.Repo.Helpers do
  alias YoutubeEx.Repo

  def with_pagination(query, opts \\ []) do
    index = Keyword.get(opts, :index, 1)
    offset = Keyword.get(opts, :offset, 20)

    query
    |> Repo.paginate(page: index, page_size: offset)
  end
end
