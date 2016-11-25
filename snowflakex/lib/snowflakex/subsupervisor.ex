defmodule Snowflakex.SubSupervisor do
  use Supervisor

  def start_link(dispenser) do
    { :ok, _pid } = Supervisor.start_link(__MODULE__, dispenser)
  end

  def init(dispenser) do
    child_processes = [
      worker(Snowflakex.Server, [dispenser])
    ]
    supervise child_processes, strategy: :one_for_one
  end
end
