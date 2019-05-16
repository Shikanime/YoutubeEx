defmodule YoutubeExApi.Router do
  use YoutubeExApi, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    plug YoutubeExApi.AuthorizationController
  end

  scope "/", YoutubeExApi do
    pipe_through :api

    post "/auth", AuthenticationController, :authenticate

    get "/users", UserController, :index
    post "/user", UserController, :register
    get "/user/:id/videos", UserVideoController, :index

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

      patch "/video/:id", VideoController, :encode
      put "/video/:id", VideoController, :update
      delete "/video/:id", VideoController, :delete

      post "/video/:id/comment", VideoCommentController, :create
    end
  end
end
