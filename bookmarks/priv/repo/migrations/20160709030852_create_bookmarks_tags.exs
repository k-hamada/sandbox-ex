defmodule Bookmarks.Repo.Migrations.CreateBookmarksTags do
  use Ecto.Migration

  def change do
    create table(:bookmarks_tags) do
      add :bookmark_id, :integer
      add :tag_id, :integer
    end
  end
end
