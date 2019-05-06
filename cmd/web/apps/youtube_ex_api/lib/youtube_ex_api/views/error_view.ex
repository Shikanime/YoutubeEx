defmodule YoutubeExApi.ErrorView do
  use YoutubeExApi, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.json", _assigns) do
  #   %{message: "Internal Server Error"}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    %{message: Phoenix.Controller.status_message_from_template(template)}
  end

  def render("400.json", %{code: code, error_stack: error_stack}) do
    %{message: "Bad Request",
      code: code
      data: error_stack}
  end

  def render("401.json", []) do
    %{message: "Unauthorized"}
  end

  def render("403.json", []) do
    %{message: "Forbidden"}
  end
end
