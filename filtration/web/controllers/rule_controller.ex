defmodule Filtration.RuleController do
  use Filtration.Web, :controller

  alias Filtration.Rule

  def index(conn, _params) do
    rules = Repo.all(Rule)
    render(conn, "index.html", rules: rules)
  end

  def new(conn, _params) do
    changeset = Rule.changeset(%Rule{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"rule" => rule_params}) do
    changeset = Rule.changeset(%Rule{}, rule_params)

    case Repo.insert(changeset) do
      {:ok, _rule} ->
        conn
        |> put_flash(:info, "Rule created successfully.")
        |> redirect(to: rule_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    rule = Repo.get!(Rule, id)
    render(conn, "show.html", rule: rule)
  end

  def edit(conn, %{"id" => id}) do
    rule = Repo.get!(Rule, id)
    changeset = Rule.changeset(rule)
    render(conn, "edit.html", rule: rule, changeset: changeset)
  end

  def update(conn, %{"id" => id, "rule" => rule_params}) do
    rule = Repo.get!(Rule, id)
    changeset = Rule.changeset(rule, rule_params)

    case Repo.update(changeset) do
      {:ok, rule} ->
        conn
        |> put_flash(:info, "Rule updated successfully.")
        |> redirect(to: rule_path(conn, :show, rule))
      {:error, changeset} ->
        render(conn, "edit.html", rule: rule, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    rule = Repo.get!(Rule, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(rule)

    conn
    |> put_flash(:info, "Rule deleted successfully.")
    |> redirect(to: rule_path(conn, :index))
  end
end
