defmodule Identicon do
  def main(input) do
    input
    |> hash_input()
  end

  def hash_input(input) do
    # :crypto.hash takes an input and returns an md5 hash,
    # which :binary.bin_to_list takes as an argument
    :crypto.hash(:md5, input)
    |> :binary.bin_to_list()
  end
end
