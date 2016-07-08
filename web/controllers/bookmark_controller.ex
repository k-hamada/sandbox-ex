defmodule Bookmarks.BookmarkController do
  use Bookmarks.Web, :controller
  alias Bookmarks.Bookmark

  def new(conn, _params) do
    changeset = Bookmark.changeset(%Bookmark{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"bookmark" => bookmark_params}) do
    changeset = Bookmark.changeset(%Bookmark{}, bookmark_params)
    case Repo.insert(changeset) do
      {:ok, bookmark} ->
        conn
        |> put_flash(:info, "Create #{bookmark.title} / #{bookmark.url}")
        |> redirect(to: bookmark_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def index(conn, _params) do
    bookmarks = Repo.all(Bookmark)
    render conn, "index.html", bookmarks: bookmarks
  end

  def show(conn, %{"id" => id}) do
    bookmark = Repo.get(Bookmark, id)
    render conn, "show.html", bookmark: bookmark
  end

  def edit(conn, %{"id" => id}) do
    bookmark = Repo.get(Bookmark, id)
    changeset = Bookmark.changeset(bookmark)
    render(conn, "edit.html", bookmark: bookmark, changeset: changeset)
  end

  def update(conn, %{"id" => id, "bookmark" => bookmark_params}) do
    bookmark = Repo.get(Bookmark, id)
    changeset = Bookmark.changeset(bookmark, bookmark_params)

    case Repo.update(changeset) do
      {:ok, bookmark} ->
        conn
        |> put_flash(:info, "Update")
        |> redirect(to: bookmark_path(conn, :show, bookmark.id))
      {:error, changeset} ->
        render(conn, "edit.html", bookmark: bookmark, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    bookmark = Repo.get(Bookmark, id)
    Repo.delete(bookmark)

    conn
    |> put_flash(:info, "Deleted")
    |> redirect(to: bookmark_path(conn, :index))
  end
end
