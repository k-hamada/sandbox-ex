defmodule Bookmarks.Repo.Migrations.CreateTag do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :title, :string, null: false

      timestamps
    end

    create unique_index(:tags, [:title])
  end
end
