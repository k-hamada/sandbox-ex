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
    bookmarks = Bookmark
    |> Bookmark.ordered
    |> Repo.all
    |> Repo.preload(:tags)
    render conn, "index.html", bookmarks: bookmarks
  end

  def show(conn, %{"id" => id}) do
    bookmark = Repo.get(Bookmark, id) |> Repo.preload(:tags)
    render conn, "show.html", bookmark: bookmark
  end

  def edit(conn, %{"id" => id}) do
    bookmark = Repo.get(Bookmark, id) |> Repo.preload(:tags)
    changeset = Bookmark.changeset(bookmark)
    render(conn, "edit.html", bookmark: bookmark, changeset: changeset)
  end

  def update(conn, %{"id" => id, "bookmark" => bookmark_params}) do
    bookmark = Repo.get(Bookmark, id) |> Repo.preload(:tags)
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



  defp clear_bookmark_relation(bookmark) do
    if Enum.count(bookmark.tags) > 0 do
      BookmarksTags
      |> BookmarksTags.from_bookmark(bookmark.id)
      |> Repo.delete_all
    end
  end

  defp parse_tags(tags) do
    tags
    |> String.trim
    |> String.split(~r{\s?,\s?}, trim: true)
    |> Enum.uniq
  end

  defp find_or_create_tag(tag) do
    query = Tag |> where([t], t.title == ^tag)
    if !Repo.one(query) do
      Repo.insert(Tag.changeset(%Tag{}, %{title: tag}))
    end
    Repo.one(query)
  end

  defp create_bookmarks_tags(bookmark, tag) do
    bt_changeset =
      BookmarksTags.changeset(
        %BookmarksTags{},
        %{bookmark_id: bookmark.id, tag_id: tag.id}
      )
    Repo.insert(bt_changeset)
  end

  defp create_relation(bookmark, bookmark_params) do
    case Dict.fetch(bookmark_params, "tags") do
      {:ok, tags} ->
        clear_bookmark_relation(bookmark)

        parse_tags(tags)
        |> Enum.map(&find_or_create_tag(&1))
        |> Enum.each(&create_bookmarks_tags(bookmark, &1))
    end
  end
end
