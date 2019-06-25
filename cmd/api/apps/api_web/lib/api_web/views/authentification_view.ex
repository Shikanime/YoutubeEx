defmodule Api.Web.AuthenticationView do
  use Api.Web, :view
  alias Api.Web.UserView
  alias Api.Web.AuthenticationView

  def render("show.json", %{authentication: authentication}) do
    %{message: "OK", data: render_one(authentication, AuthenticationView, "authentication.json")}
  end

  def render("authentication.json", %{authentication: authentication}) do
    %{token: authentication.token, user: render_one(authentication.user, UserView, "user.json")}
  end
end
