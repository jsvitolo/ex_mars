defmodule ExMars.CLI do
  def main([file]) do
    case File.read(file) do
      {:ok, inputs} ->
        ExMars.start(inputs) |> visualize()

      {:error, _} ->
        {:error, "couldn't read #{file}"}
    end
  end

  def main(_) do
    IO.puts("Usage: toy_robot commands.txt")
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
