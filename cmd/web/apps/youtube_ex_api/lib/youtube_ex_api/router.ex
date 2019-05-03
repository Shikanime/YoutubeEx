defmodule YoutubeExApi.Router do
  use YoutubeExApi, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", YoutubeExApi do
    pipe_through :api

    post "/auth", AuthController, :create
    resources "/users", UserController, except: [:new, :edit]
    resources "/videos", VideoController, except: [:new, :edit]
    resources "/comments", CommentController, except: [:new, :edit]
  end
end
