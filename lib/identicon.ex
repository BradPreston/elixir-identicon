defmodule Identicon do
  def main(input) do
    input
    |> hash_input()
    |> pick_color()
  end

  def pick_color(image) do
    # image is referencing the %Identicon.Image{} struct

    # Using pattern matching, we are checking that
    # 1. image is an %Identicon.Image{},
    # 2. the Image struct has a hex property, and
    # 3. grabs the first 3 variables in the image (hex list) and ignores the rest
    %Identicon.Image{hex: [r, g, b | _tail]} = image
    [r, g, b]
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
