defmodule Bookmarks.Bookmark do
  use Bookmarks.Web, :model

  schema "bookmarks" do
    field :title, :string
    field :url, :string
    many_to_many :tags, Bookmarks.Tag, join_through: "bookmarks_tags"

    timestamps
  end

  @required_fields ~w(title url)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:url)
  end

  def ordered(query) do
    query
    |> order_by([t], desc: t.id)
  end
end
