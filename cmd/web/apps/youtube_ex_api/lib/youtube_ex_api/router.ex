defmodule YoutubeExApi.Router do
  use YoutubeExApi, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", YoutubeExApi do
    pipe_through :api

    post "/auth", AuthController, :create

    get "/users", UserController, :index
    scope "/user" do
      get "/:id", UserController, :show
      put "/:id", UserController, :update
      patch "/:id", UserController, :update
      delete "/:id", UserController, :delete

      get "/:id/videos", UserVideoController, :index
      post "/:id/video", UserVideoController, :create
    end

    get "/videos", VideoController, :index
    scope "/video" do
      get "/:id", VideoController, :show
      put "/:id", VideoController, :update
      patch "/:id", VideoController, :encode
      delete "/:id", VideoController, :delete

      get "/:id/comments", VideoCommentController, :index
      post "/:id/comment", VideoCommentController, :create
    end
  end
end
