defmodule Filtration.EntryTest do
  use Filtration.ModelCase

  alias Filtration.Entry

  @valid_attrs %{is_exclude: true, registered_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, title: "some content", url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Entry.changeset(%Entry{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Entry.changeset(%Entry{}, @invalid_attrs)
    refute changeset.valid?
  end
end
