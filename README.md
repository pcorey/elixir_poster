# ElixirPoster

For a detailed rundown of why this project exists, please ready [Build Your Own Code Poster with Elixir](http://www.east5th.co/blog/2017/02/13/build-your-own-code-poster-with-elixir/). The general idea was to create a [commits.io](https://commits.io/) style poster for a client of mine.

During that processes, I decided to make an Elixir poster as well, to celebrate the language I wrote to build the tool.

## Warning

Take this tool for what it is. It's a utility I hacked together to generate a one-off poster specifically for my needs. It's not a general purpose poster making tool, and may not work for your use case.

I've published this repo as a learning tool and as a supplement to [this article](http://www.east5th.co/blog/2017/02/13/build-your-own-code-poster-with-elixir/). It is not intended to be a quality piece of standlone software.

Read below if you're still intent on giving it a spin:

## Instructions

This is an Elixir project. You'll need Elixir installed before running this application. Check out the [Elixir Introduction](http://elixir-lang.org/getting-started/introduction.html) for help getting up to speed. Once you've got Elixir up and running, and cloned this project locally, proceed to the following steps.

1. Scale an image of your choosing to `1.667x1` and resize to approximately `398px` by `300px`. As an example, [here’s the image](https://s3-us-west-1.amazonaws.com/www.east5th.co/img/poster_source_image.png) I used to generate the Elixir poster.
2. Gather the source code you want to use in the poster into a single file.
3. From the project root, start an interactive shell (`iex -S mix`)
4. Call the `ElixirPoster.go` function. By default, this assumes that your image is called `image.png`, and your source file is called `code` in the root of the project. These options can be overridden, if desired. See the `ElixirPoster.go` definition.
5. On my machine, with the given source image, it takes approximately 3 seconds to generate the final poster. The final result is an SVG saved to `out.svg`.
6. Open `out.svg` in Inkscape, export to PNG, print!

## Simpler Instructions
1. Put any code you want used in a file `code`
2. Put the logo of your choosing in a file, `image.png`
3. `mix deps.get`
4. `iex -S mix`
5. `ElixirPoster.go`
