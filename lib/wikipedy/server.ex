defmodule Wikipedy.Server do
  use GenServer

  # API
  def start_link do
    GenServer.start_link(__MODULE__, [], [name: {:global, __MODULE__}])
  end

  def today_topic do
    GenServer.call({:global, __MODULE__}, :today_topic)
  end

  # Callbacks
  def init([]) do
    :random.seed(:os.timestamp)
    topics = "today.txt" |> File.read! |> String.split("\n")

    {:ok, topics}
  end

  def handle_call(:today_topic, _from, topics) do
    random_topic =
      topics
      |> Enum.shuffle
      |> List.first

    {:reply, random_topic, topics}
  end
end
