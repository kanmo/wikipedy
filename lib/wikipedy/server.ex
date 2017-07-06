defmodule Wikipedy.Server do
  use GenServer

  # API
  def start_link do
    GenServer.start_link(__MODULE__, [], [name: {:global, __MODULE__}])
  end

  def init([]) do
    :random.seed(:os.timestamp)
    my_loop
    {:ok, []}
  end

  def my_loop do
    Process.send_after(self, :today_topic, 1_500)
  end

  def handle_info(:today_topic, topics) do
    topics =
      case Enum.empty?(topics) do
        true ->
          case Wikipedy.TopicFetcher.topics do
            {:ok, list} -> list

            {:error, reason} ->
              IO.puts(reason)
              topics

          end
        false -> topics
      end

    IO.puts(Enum.random(topics))
    my_loop
    {:noreply, topics }
  end

end
