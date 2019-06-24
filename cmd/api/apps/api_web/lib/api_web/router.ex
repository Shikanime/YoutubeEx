defmodule Api.Web.Router do
  use Api.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    plug Api.Web.AuthorizationController
  end

  scope "/", Api.Web do
    pipe_through :api

    post "/auth", AuthenticationController, :index

    get "/users", UserController, :index
    post "/user", UserController, :create
    get "/user/:id/videos", UserVideoController, :index

    get "/videos", VideoController, :index
    get "/video/:id", VideoController, :show
    get "/video/:id/comments", VideoCommentController, :index

    scope "/" do
      pipe_through :protected

      get "/user/:id", UserController, :show
      put "/user/:id", UserController, :update
      patch "/user/:id", UserController, :update
      delete "/user/:id", UserController, :delete
      post "/user/:id/video", UserVideoController, :create

      patch "/video/:id", VideoController, :patch
      put "/video/:id", VideoController, :update
      delete "/video/:id", VideoController, :delete

      post "/video/:id/comment", VideoCommentController, :create
    end
  end
end
