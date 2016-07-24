defmodule Filtration.Commands.Check do
  require Logger
  alias Filtration.{Repo, Entry, Rule}

  def execute(all \\ false) do
    Logger.info "Filtration.Commands.Check"
    init_rules(:regex_rules,  Rule |> Rule.only_regex,  &Regex.compile!/1)
    init_rules(:domain_rules, Rule |> Rule.only_domain, &(&1))

    entries =
      if all do
        Entry
        |> Repo.all
      else
        Entry
        |> Entry.is_exclude(false)
        |> Repo.all
      end

    entries_checked_by_domain = entries |> check_by(:domain_rules)
    entries_checked_by_regex  = entries |> check_by(:regex_rules)

    Enum.concat(entries_checked_by_domain, entries_checked_by_regex)
    |> Enum.map(&to_exclude/1)
    |> Enum.map(&update/1)
  end

  defp to_exclude(entry) do
    Ecto.Changeset.change entry, is_exclude: true
  end

  defp update(changeset) do
    case Repo.update(changeset) do
      {:ok, entry} ->
        Logger.info "success: #{entry.url}"
      {:error, changeset} ->
        Logger.info "fail: #{changeset.changes.url}"
        IO.inspect changeset.errors
    end
  end

  def init_rules(name, rules, translate \\ fn rule -> rule end) do
    Agent.start_link(fn -> [] end, name: name)

    rules
    |> Repo.all
    |> Enum.map(&add_rule(name, &1, translate))
  end

  defp add_rule(name, rule, translate) do
    Agent.update(name, fn list -> [translate.(rule.rule) | list] end)
  end

  defp check_by(entries, rule_name) do
    entries
    |> Enum.filter(&check_by_rule(rule_name, &1))
  end

  defp check_by_rule(name = :domain_rules, entry) do
    uri = URI.parse(entry.url)
    Agent.get(name, fn rules ->
      rules |> Enum.any?(&check_by_rule_at_domain_pattern(uri, &1))
    end)
  end

  defp check_by_rule(name = :regex_rules, entry) do
    Agent.get(name, fn rules ->
      rules |> Enum.any?(&check_by_rule_at_regex_pattern(entry, &1))
    end)
  end

  defp check_by_rule_at_domain_pattern(uri, pattern) do
    case uri do
      %URI{host: ^pattern} -> true
      _ -> false
    end
  end

  defp check_by_rule_at_regex_pattern(entry, pattern) do
    Regex.match?(pattern, entry.url)
  end
end
