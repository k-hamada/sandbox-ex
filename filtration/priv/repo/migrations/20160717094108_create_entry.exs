defmodule Filtration.Repo.Migrations.CreateEntry do
  use Ecto.Migration

  def change do
    create table(:entries) do
      add :url, :string
      add :title, :string
      add :registered_at, :datetime
      add :is_exclude, :boolean, default: false, null: false

      timestamps()
    end

  end
end
