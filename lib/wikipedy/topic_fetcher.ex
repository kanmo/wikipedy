defmodule Wikipedy.TopicFetcher do

  def topics do
    {{_,m,d}, _} = :calendar.local_time
    case HTTPoison.get(URI.encode("https://ja.wikipedia.org/wiki/#{m}月#{d}日")) do
      {:ok, %HTTPoison.Response{body: body}} ->
        topic_elms = String.split(body, "</h2>") |> Enum.at(2)

        topics =
          Floki.find(topic_elms, "mw-content-text, ul")
          |> Enum.at(0)
          |> Floki.text
          |> String.split("。")

        {:ok, topics}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
