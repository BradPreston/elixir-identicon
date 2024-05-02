defmodule Identicon do
  def main(input) do
    input
    |> hash_input()
    |> pick_color()
    |> build_grid()
    |> filter_odd_squares()
    |> build_pixel_map()
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    # creates a list of tuples containing tuples of x and y points
    pixel_map =
      Enum.map(grid, fn {_hex, index} ->
        horizontal = rem(index, 5) * 50
        vertical = div(index, 5) * 50

        top_left = {horizontal, vertical}
        bottom_right = {horizontal + 50, vertical + 50}

        {top_left, bottom_right}
      end)

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    # returns only values in the list that are divisible by 2 (even)
    # rem calculates remainder (modulo)
    grid = Enum.filter(grid, fn {hex, _index} -> rem(hex, 2) == 0 end)

    %Identicon.Image{image | grid: grid}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk_every(3, 3, :discard)
      # use ampersand to tell Elixir that you're passing a reference to a function
      # if there were multiple mirror_row methods, we tell Elixir that we want the one with an arity of 1
      |> Enum.map(&mirror_row/1)
      |> List.flatten()
      # converts the list into a list of two value tuples
      # each tuple contains the value and its index
      |> Enum.with_index()

    %Identicon.Image{image | grid: grid}
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
