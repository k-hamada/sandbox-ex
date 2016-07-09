defmodule Bookmarks.Tag do
  use Bookmarks.Web, :model

  schema "tags" do
    field :title, :string
    many_to_many :bookmarks, Bookmarks.Bookmark, join_through: "bookmarks_tags"

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title])
    |> validate_required([:title])
  end
end
