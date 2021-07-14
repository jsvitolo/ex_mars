defmodule ExMars.CLI do
  def main([file]) do
    with :ok <- file_exists?(file),
         {:ok, inputs} <- read_file(file) do
      ExMars.start(inputs) |> visualize()
    end
  end

  def main(_) do
    IO.puts("Usage: ./ex_mars test/support.input.txt")
  end

  defp file_exists?(file) do
    if File.exists?(file) do
      :ok
    else
      IO.puts("The file #{file} does not exist")
    end
  end

  defp read_file(file) do
    case File.read(file) do
      {:ok, inputs} -> {:ok, inputs}
      {:error, _} -> {:error, "couldn't read #{file}"}
    end
  end

  defp visualize({:error, message}) do
    IO.puts(:stderr, "Error: #{message}")
  end

  defp visualize(string) when is_binary(string) do
    IO.puts(string)
  end

  defp visualize(list) when is_list(list) do
    IO.puts(Enum.join(list, "\n"))
  end
end
