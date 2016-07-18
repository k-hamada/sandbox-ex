defmodule Filtration.Repo.Migrations.CreateIndexToEntries do
  use Ecto.Migration

  def change do
    create index(:entries, [:url], unique: true)
  end
end
