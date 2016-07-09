defmodule Bookmarks.BookmarksTags do
  use Bookmarks.Web, :model

  schema "bookmarks_tags" do
    field :bookmark_id, :integer
    field :tag_id, :integer
  end

  @required_fields ~w(bookmark_id tag_id)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
