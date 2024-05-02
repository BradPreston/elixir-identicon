defmodule Identicon do
  def main(input) do
    input
    |> hash_input()
    |> pick_color()
    |> build_grid()
  end

  def build_grid(%Identicon.Image{hex: hex} = _image) do
    hex
    |> Enum.chunk_every(3, 3, :discard)
    # use ampersand to tell Elixir that you're passing a reference to a function
    # if there were multiple mirror_row methods, we tell Elixir that we want the one with an arity of 1
    |> Enum.map(&mirror_row/1)
  end

  defp mirror_row(row) do
    # defp means define a private method
    [first, second | _tail] = row
    ## take the row list and append the second and first element to the end
    row ++ [second, first]
  end

  ## Pattern match the image as an argument
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    # image is referencing the %Identicon.Image{} struct

    # Using pattern matching, we are checking that
    # 1. image is an %Identicon.Image{},
    # 2. the Image struct has a hex property, and
    # 3. grabs the first 3 variables in the image (hex list) and ignores the rest

    # Create a new Image (to prevent modifying existing data) and update the color value
    # Color is set with a tuple instead of a list so that each index has meaning
    %Identicon.Image{image | color: {r, g, b}}
  end

  def hash_input(input) do
    # :crypto.hash takes an input and returns an md5 hash,
    # which :binary.bin_to_list takes as an argument
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end
end
