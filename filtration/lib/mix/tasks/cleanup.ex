defmodule Mix.Tasks.Cleanup do
  use Mix.Task
  @shortdoc "Cleanup"

  def run(_args) do
    Mix.Task.run "app.start"
    Filtration.Commands.Cleanup.execute
  end
end
