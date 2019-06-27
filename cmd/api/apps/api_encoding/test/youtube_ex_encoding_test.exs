defmodule Api.EncodingTest do
  use ExUnit.Case
  doctest Api.Encoding

  test "greets the world" do
    assert Api.Encoding.hello() == :world
  end
end
