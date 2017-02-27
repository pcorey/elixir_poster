defmodule ElixirPoster do
  require Logger
  alias ElixirPoster.PosterData

  @doc """
  iex> ElixirPoster.to_hex {50, 150, 250}
  "#3296FA"
  iex> ElixirPoster.to_hex {255, 0, 128}
  "#FF0080"
  """
  def to_hex({r, g, b}) do
    "#" <>
    (r |> :binary.encode_unsigned |> Base.encode16) <>
    (g |> :binary.encode_unsigned |> Base.encode16) <>
    (b |> :binary.encode_unsigned |> Base.encode16)
  end

  @doc """
  iex> ElixirPoster.to_hex {50, 150, 250}
  "#3296FA"
  iex> ElixirPoster.to_hex {255, 0, 128}
  "#FF0080"
  """
  def to_hex({r, g, b, a}) do
    "#" <>
    (r |> :binary.encode_unsigned |> Base.encode16) <>
    (g |> :binary.encode_unsigned |> Base.encode16) <>
    (b |> :binary.encode_unsigned |> Base.encode16) <>
    (a |> :binary.encode_unsigned |> Base.encode16)
  end

  @doc """
  iex> ElixirPoster.join_code("if (true) {\\n    bang;\\n}")
  "if (true) { bang; }"
  iex> ElixirPoster.join_code("{\\n    '    ';\\n}")
  "{ '    '; }"
  iex> ElixirPoster.join_code("  a \\n bb\\n \\tc\\n    d  ")
  "a bb c d"
  """
  def join_code(code) do
    Logger.debug("Joining code...")
    code
    |> String.trim
    |> String.replace(~r/\s*\n+\s*/, " ")
    |> String.replace(~r/\s/," ")
  end

  def load_code(data = %PosterData{code_path: code_path}) do
    Logger.debug("Loading code from '#{code_path}'...")
    code = code_path
    |> File.read!
    |> join_code
    |> String.codepoints
    %{data | code: code}
  end

  def load_image(data = %PosterData{image_path: image_path}) do
    Logger.debug("Loading image from '#{image_path}'...")
    {:ok, image} = Imagineer.load(image_path)
    %{data | image: image}
  end

  def construct_text_elements(data = %PosterData{code: code,
                                                 ratio: ratio,
                                                 image: %{width: width, pixels: pixels}}) do
    Logger.debug("Constructing text elements...")
    text_elements = pixels
    |> List.flatten
    |> Enum.zip(code)
    |> Enum.reduce({1, []}, fn
      {pixel, character}, {i, acc} ->
        x = rem(i, width)
        y = div(i, width)
        fill = to_hex(pixel)
        x_dst = x * ratio
        case {x, acc} do
          {1, _acc} ->
            {i + 1, [{:text, %{x: x_dst, y: y, fill: fill}, character} | acc]}
          {_x, [{:text, element = %{fill: ^fill}, text} | tail]} ->
            {i + 1, [{:text, element, text <> character} | tail]}
          {_x, _acc} ->
            {i + 1, [{:text, %{x: x_dst, y: y, fill: fill}, character} | acc]}
        end
    end)
    |> elem(1)
    %{data | text_elements: text_elements}
  end

  def construct_svg(data = %PosterData{text_elements: text_elements,
                                       ratio: ratio,
                                       final_width: final_width,
                                       final_height: final_height,
                                       image: %{width: width, height: height}}) do
    Logger.debug("Constructing svg with #{length text_elements} text elements...")
    svg = {:svg,
           %{
             viewBox: "0 0 #{width*ratio} #{height}",
             xmlns: "http://www.w3.org/2000/svg",
             style: "font-family: 'Source Code Pro'; font-size: 1; font-weight: 900;",
             width: final_width,
             height: final_height,
             "xml:space": "preserve"
           },
           text_elements}
    |> XmlBuilder.generate
    %{data | svg: svg}
  end

  def save_svg(%PosterData{svg: svg, out_path: out_path}) do
    Logger.debug("Saving svg to '#{out_path}'...")
    {:ok, file} = File.open(out_path, [:write])
    IO.binwrite(file, svg)
    File.close(file)
  end

  def go(ratio, final_width, final_height, code_path, image_path, out_path) do
    %PosterData{
      ratio: ratio,
      final_width: final_width,
      final_height: final_height,
      code_path: code_path,
      image_path: image_path,
      out_path: out_path
    }
    |> load_code
    |> load_image
    |> construct_text_elements
    |> construct_svg
    |> save_svg
  end

  def go, do: go(0.6, 3150, 4050, "./code", "./image.png", "out.svg")

end
