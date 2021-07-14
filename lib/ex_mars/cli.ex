defmodule ExMars.CLI do
  def main([file]) do
    case File.read(file) do
      {:ok, commands} ->
        ExMars.InputInterpreter.interpret(commands)

      # |> suppress_output(opts)

      {:error, _} ->
        {:error, "couldn't read #{file}"}
    end
  end

  def main(_) do
    IO.puts("Usage: toy_robot commands.txt")
  end
end
