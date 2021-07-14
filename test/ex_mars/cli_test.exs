defmodule ExMars.CLITest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  alias ExMars.CLI

  describe "CLI.man/1" do
    test "input from file" do
      {:ok, contents} = File.read("test/support/output.txt")

      assert capture_io(fn ->
               CLI.main(["test/support/input.txt"])
             end) == contents
    end

    test "returns error when file not found" do
      assert {:error, "couldn't read file_not_exists.txt"} = CLI.main(["file_not_exists.txt"])
    end
  end
end
