defmodule Filtration.RuleTest do
  use Filtration.ModelCase

  alias Filtration.Rule

  @valid_attrs %{is_domain: true, is_regex: true, rule: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Rule.changeset(%Rule{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Rule.changeset(%Rule{}, @invalid_attrs)
    refute changeset.valid?
  end
end
