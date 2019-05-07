defmodule YoutubeExApi.Router do
  use YoutubeExApi, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    plug YoutubeExApi.AuthenticationController
  end

  scope "/", YoutubeExApi do
    pipe_through :api

    post "/auth", AuthController, :authenticate

    get "/users", UserController, :list
    post "/user", UserController, :register
    get "/user/:id/videos", UserVideoController, :list

    get "/videos", VideoController, :index
    get "/video/:id", VideoController, :show
    get "/video/:id/comments", VideoCommentController, :index

    scope "/" do
      pipe_through :protected

      get "/user/:id", UserController, :get
      put "/user/:id", UserController, :update
      patch "/user/:id", UserController, :update
      delete "/user/:id", UserController, :delete
      post "/user/:id/video", UserVideoController, :create

      patch "/:id", VideoController, :encode
      put "/:id", VideoController, :update
      delete "/:id", VideoController, :delete

      post "/video/:id/comment", VideoCommentController, :create
    end
  end
end
