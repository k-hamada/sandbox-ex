defmodule Filtration.Entry do
  use Filtration.Web, :model
  use Calecto.Schema, usec: true

  schema "entries" do
    field :url, :string
    field :title, :string
    field :registered_at, Calecto.DateTimeUTC
    field :is_exclude, :boolean, default: false

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:url, :title, :registered_at, :is_exclude])
    |> validate_required([:url, :title, :registered_at, :is_exclude])
  end
end
