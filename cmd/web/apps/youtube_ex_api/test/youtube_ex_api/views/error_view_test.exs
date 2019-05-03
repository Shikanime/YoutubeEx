defmodule YoutubeExApi.ErrorViewTest do
  use YoutubeExApi.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.json" do
    assert render(YoutubeExApi.ErrorView, "404.json", []) == %{errors: "Not Found"}
  end

  test "renders 500.json" do
    assert render(YoutubeExApi.ErrorView, "500.json", []) ==
             %{errors:  "Internal Server Error"}
  end
end
