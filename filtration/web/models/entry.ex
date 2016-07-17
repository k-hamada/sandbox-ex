defmodule Filtration.Entry do
  use Filtration.Web, :model

  schema "entries" do
    field :url, :string
    field :title, :string
    field :registered_at, Ecto.DateTime
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
