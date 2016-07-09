defmodule Bookmarks.TagController do
  use Bookmarks.Web, :controller
  alias Bookmarks.Tag

  def index(conn, _params) do
    tags = Tag
    |> Repo.all
    |> Repo.preload(:bookmarks)
    render conn, "index.html", tags: tags
  end

  def show(conn, %{"id" => id}) do
    tag = Repo.get(Tag, id) |> Repo.preload(:bookmarks)
    render conn, "show.html", tag: tag
  end

  def show_tag(conn, %{"tag" => tag}) do
    tag = Repo.get_by(Tag, title: tag) |> Repo.preload(:bookmarks)
    render conn, "show.html", tag: tag
  end

  def delete(conn, %{"id" => id}) do
    tag = Repo.get(Tag, id)
    Repo.delete(tag)

    conn
    |> put_flash(:info, "Deleted")
    |> redirect(to: tag_path(conn, :index))
  end
end
