defmodule Bookmarks.BookmarkController do
  use Bookmarks.Web, :controller
  alias Bookmarks.Bookmark
  alias Bookmarks.Tag
  alias Bookmarks.BookmarksTags

  def new(conn, _params) do
    changeset = Bookmark.changeset(%Bookmark{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"bookmark" => bookmark_params}) do
    changeset = Bookmark.changeset(%Bookmark{}, bookmark_params)
    case Repo.insert(changeset) do
      {:ok, bookmark} ->
        create_relation(bookmark, bookmark_params)

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
        create_relation(bookmark, bookmark_params)
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

  defp create_relation(bookmark, bookmark_params) do
    case Dict.fetch(bookmark_params, "tags") do
      {:ok, tags} ->
        if Enum.count(bookmark.tags) > 0 do
          BookmarksTags |> where([t], t.bookmark_id == ^bookmark.id) |> Repo.delete_all
        end

        String.split(tags, ",", trim: true)
        |> Enum.map(fn(tag) ->
          query = Tag |> where([t], t.title == ^tag)
          if !Repo.one(query) do
            Repo.insert(Tag.changeset(%Tag{}, %{title: tag}))
          end
          Repo.one(query)
        end)
        |> Enum.each(fn(tag_repo) ->
            bt_changeset =
              BookmarksTags.changeset(%BookmarksTags{}, %{bookmark_id: bookmark.id, tag_id: tag_repo.id})
            Repo.insert(bt_changeset)
        end)
    end
  end
end
