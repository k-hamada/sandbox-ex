defmodule Snowflakex do
  use Application

  def start(_type, _args) do
    { :ok, _pid } = Snowflakex.Supervisor.start_link
  end
end
