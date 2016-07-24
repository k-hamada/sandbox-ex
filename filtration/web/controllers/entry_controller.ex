defmodule Filtration.EntryController do
  use Filtration.Web, :controller

  alias Filtration.Entry

  def index(conn, _params) do
    entries =
      Entry
      |> Entry.ordered
      |> Entry.is_exclude(false)
      |> Repo.all
    render(conn, "index.html", entries: entries)
  end

  def edit(conn, %{"id" => id}) do
    entry = Repo.get!(Entry, id)
    changeset = Entry.changeset(entry)
    render(conn, "edit.html", entry: entry, changeset: changeset)
  end

  def update(conn, %{"id" => id, "entry" => entry_params}) do
    entry = Repo.get!(Entry, id)
    changeset = Entry.changeset(entry, entry_params)

    case Repo.update(changeset) do
      {:ok, entry} ->
        conn
        |> put_flash(:info, "Entry updated successfully.")
        |> redirect(to: entry_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", entry: entry, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    entry = Repo.get!(Entry, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(entry)

    conn
    |> put_flash(:info, "Entry deleted successfully.")
    |> redirect(to: entry_path(conn, :index))
  end
end
