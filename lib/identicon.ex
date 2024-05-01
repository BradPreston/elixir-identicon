defmodule Identicon do
  def main(input) do
    input
    |> hash_input()
    |> pick_color()
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
