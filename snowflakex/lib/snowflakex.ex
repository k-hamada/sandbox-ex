defmodule Snowflakex do
  use Application

  def start(_type, _args) do
    {:ok, _pid} = Snowflakex.Server.start_link()
  end
end
