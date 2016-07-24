defmodule Mix.Tasks.Crawl do
  use Mix.Task
  @shortdoc "Crawl"

  def run(_args) do
    Mix.Task.run "app.start"
    Filtration.Commands.Crawl.execute
    Filtration.Commands.Check.execute
  end
end
