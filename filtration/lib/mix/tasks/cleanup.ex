defmodule Mix.Tasks.Cleanup do
  use Mix.Task
  require Ecto.Query
  require Logger
  alias Filtration.{Repo, Entry}

  @shortdoc "Cleanup"

  def run(_args) do
    Mix.Task.run "app.start"

    Entry
    |> Entry.ordered
    |> cleanup_exclude_entries
    |> cleanup_overflow_entries(250)
  end

  def cleanup_exclude_entries(entries) do
    entries
      |> Entry.is_exclude(true)
      |> Repo.all
      |> Enum.map(&delete/1)

    entries
  end

  def cleanup_overflow_entries(entries, offset) do
    entries
    |> Entry.is_exclude(false)
    |> Ecto.Query.offset(^offset)
    |> Repo.all
    |> Enum.map(&delete/1)

    entries
  end

  defp delete(entry) do
    case Repo.delete(entry) do
      {:ok, entry} ->
        Logger.info "success: #{entry.url}"
      {:error, changeset} ->
        Logger.info "fail: #{changeset.changes.url}"
        IO.inspect changeset.errors
    end
  end
end
