defmodule ElixirPosterTest do
  use ExUnit.Case
  doctest ElixirPoster

  defp test_construct_text(code, pixels, expected) do
    width = length(Enum.at(pixels, 0))
    height = length(pixels)
    assert ElixirPoster.construct_text_elements(%ElixirPoster.PosterData{
      code: String.codepoints(code),
      ratio: 1,
      image: %{
        width: width,
        height: height,
        pixels: pixels
      }}).text_elements == expected
  end

  test "of constructing a single text element" do
    test_construct_text(
      "a",
      [[{255, 255, 255}]],
      [{:text, %{fill: "#FFFFFF", x: 0, y: 0}, "a"}])
  end

  test "of constructing multiple text elements" do
    test_construct_text(
      "abcd",
      [[{1, 1, 1}, {2, 2, 2}],
       [{3, 3, 3}, {4, 4, 4}]],
      [{:text, %{fill: "#010101", x: 0, y: 0}, "a"},
       {:text, %{fill: "#020202", x: 1, y: 0}, "b"},
       {:text, %{fill: "#030303", x: 0, y: 1}, "c"},
       {:text, %{fill: "#040404", x: 1, y: 1}, "d"},
      ])
  end

  test "of merging text elements of the same color" do
    test_construct_text(
      "abcdef",
      [[{1, 1, 1}, {1, 1, 1}, {3, 3, 3}],
       [{4, 4, 4}, {6, 6, 6}, {6, 6, 6}]],
      [{:text, %{fill: "#010101", x: 0, y: 0}, "ab"},
       {:text, %{fill: "#030303", x: 2, y: 0}, "c"},
       {:text, %{fill: "#040404", x: 0, y: 1}, "d"},
       {:text, %{fill: "#060606", x: 1, y: 1}, "ef"},
      ])
  end

end
