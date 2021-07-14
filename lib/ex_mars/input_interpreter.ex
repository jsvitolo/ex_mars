defmodule ExMars.InputInterpreter do
  @moduledoc """
  InputInterpreter
  """

  alias ExMars.{Rover, Rover.Position}

  def interpret(input) do
    with {:ok, tokens} <- tokenize(input),
         {:ok, commands} <- do_interpret(tokens),
         do: to_structs(commands)
  end

  defp tokenize(string) do
    string
    |> to_charlist
    |> :input_lexer.string()
    |> case do
      {:ok, tokens, _} ->
        {:ok, tokens}

      {:error, {line, :input_lexer, {:illegal, token}}, _} ->
        {:error, "illegal token '#{token}' found on line #{line}"}
    end
  end

  defp do_interpret(tokens) do
    case :input_parser.parse(tokens) do
      {:ok, commands} ->
        {:ok, commands}

      {:error, {line, :input_parser, [message, [token]]}} ->
        {:error, "#{message}#{token} at line #{line}"}
    end
  end

  defp to_structs(commands) do
    {world_map_size, rovers} = commands

    rovers =
      rovers
      |> Enum.map(fn {{x, y, direction}, commands} ->
        position = %Position{x: x, y: y, direction: to_string(direction)}
        commands = commands |> Enum.map(&to_string/1)
        Rover.new(position, commands)
      end)

    {world_map_size, rovers}
  end
end
