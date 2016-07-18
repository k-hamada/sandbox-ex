defmodule Filtration.Rule do
  use Filtration.Web, :model

  schema "rules" do
    field :rule, :string
    field :is_regex, :boolean, default: false
    field :is_domain, :boolean, default: false

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:rule, :is_regex, :is_domain])
    |> validate_required([:rule, :is_regex, :is_domain])
  end
end
