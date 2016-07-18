defmodule Filtration.Repo.Migrations.CreateRule do
  use Ecto.Migration

  def change do
    create table(:rules) do
      add :rule, :string
      add :is_regex, :boolean, default: true, null: false
      add :is_domain, :boolean, default: false, null: false

      timestamps()
    end

  end
end
