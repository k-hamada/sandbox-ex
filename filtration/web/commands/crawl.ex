defmodule Filtration.Commands.Crawl do
  alias Filtration.{Repo, Entry}
  require Logger

  @url "http://b.hatena.ne.jp/entrylist?sort=hot&threshold=3&mode=rss"

  def execute do
    Logger.info "Filtration.Commands.Crawl"

    @url
    |> HTTPoison.get
    |> evaluate
    |> Enum.map(&to_changeset/1)
    |> Enum.map(&insert/1)
  end

  defp evaluate({:error, _}), do: ""
  defp evaluate({:ok, %HTTPoison.Response{status_code: 200} = response}) do
    response.body
    |> Floki.find("item")
    |> Enum.map(&perse_body/1)
  end

  defp perse_body(item) do
    %{
      url: parse_item(item, "link"),
      title: parse_item(item, "title"),
      registered_at: parse_item(item, "dc:date") |> to_datetime,
      is_exclude: false,
    }
  end

  defp parse_item(item, tag) do
    item
    |> Floki.find(tag)
    |> Floki.text
  end

  defp to_datetime(date) do
    case date |> Calendar.DateTime.Parse.rfc3339_utc do
      {:ok, datetime} -> datetime
      {:_, _} -> DateTime.now
    end
  end

  defp to_changeset(params) do
    Entry.changeset(%Entry{}, params)
  end

  defp insert(changeset) do
    case Repo.insert(changeset) do
      {:ok, entry} ->
        Logger.info "success: #{entry.url}"
      {:error, %{errors: [url: {"has already been taken", []}]}} ->
        Logger.info "dup: #{changeset.changes.url}"
      {:error, changeset} ->
        Logger.info "fail: #{changeset.changes.url}"
        IO.inspect changeset.errors
    end
  end
end
