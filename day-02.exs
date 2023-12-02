defmodule Day02Part01 do
  def answer(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(0, fn line, acc -> 
      {ok, id} = process_line(line) 
      if ok, do: acc + String.to_integer(id |> List.last()), else: acc
    end)
  end

  def process_line(line) do
    [game_id, events_str] = String.split(line, ":", trim: true)
    id = String.split(game_id, " ")
    ok = process_events(events_str)
    {ok, id}
  end

  def process_events(events_str) do
    events_str
    |> String.split(";", trim: true)
    |> Enum.all?(fn event -> process_balls(event) end)
  end

  def process_balls(balls_str) do
    balls_str
    |> String.split(",", trim: true)
    |> Enum.all?(fn ball -> 
      [n, color] = String.split(String.trim(ball))
      allowed_count =  %{"red" => 12, "green" => 13, "blue" => 14}
      n_int = String.to_integer(n)
      allowed = Map.get(allowed_count, color, 0)
      n_int <= allowed
    end)
  end
end

defmodule Day02Part02 do
  def answer(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.replace(&1, ~r/Game \d++:\ /, ""))
    |> Enum.map(&String.split(&1, "; ", trim: true))
    |> Enum.map(&process_events/1)
    |> Enum.map(&Enum.reduce(&1, 1, fn {_key, val}, acc -> acc * val end))
    |> Enum.sum()
  end

  defp process_events(events_list) do
    Enum.reduce(events_list, %{"red" => 0, "blue" => 0, "green" => 0}, &update_color_count/2)
  end

  defp update_color_count(str, acc) do
    str
    |> String.split(", ")
    |> Enum.reduce(acc, &update_color/2)
  end

  defp update_color(color_count_str, acc) do
    [count_str, color] = String.split(color_count_str, " ")
    count = String.to_integer(count_str)
    updated_acc = case Map.get(acc, color) do
    nil -> Map.put(acc, color, count)
    current_count when count > current_count -> Map.put(acc, color, count)
    _ -> acc
    end

    updated_acc
  end
end
