defmodule Mix.Tasks.Check do
  use Mix.Task
  @shortdoc "Check"

  def run(_args) do
    Mix.Task.run "app.start"
    Filtration.Commands.Check.execute(true)
  end
end
