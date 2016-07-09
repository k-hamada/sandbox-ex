defmodule Bookmarks.Repo.Migrations.CreateBookmark do
  use Ecto.Migration

  def change do
    create table(:bookmarks) do
      add :title, :string
      add :url, :string, null: false

      timestamps
    end

    create unique_index(:bookmarks, [:url])
  end
end
