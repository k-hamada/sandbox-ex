defmodule Snowflakex.TicketDispenser do
  use GenServer

  def start_link(current_number \\ 0) do
    { :ok,_pid } = GenServer.start_link(__MODULE__, current_number)
  end

  def get_value do
    GenServer.call __MODULE__, :get_value
  end

  def get_value(pid) do
    GenServer.call pid, :get_value
  end

  def handle_call(:get_value, _from, current_value) do
    { :reply, current_value, current_value + 1 }
  end
end
