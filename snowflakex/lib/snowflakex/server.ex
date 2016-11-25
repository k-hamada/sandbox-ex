defmodule Snowflakex.Server do
  use GenServer

  def start_link(dispenser) do
    GenServer.start_link(__MODULE__, dispenser, name: __MODULE__)
  end

  def new_id do
    GenServer.call __MODULE__, :new_id
  end

  def init(dispenser) do
    maschine_id = Snowflakex.TicketDispenser.get_value dispenser
    sequence = 0
    { :ok, { maschine_id, sequence } }
  end

  def handle_call(:new_id, _from, { maschine_id, sequence }) do
    new_id = Snowflakex.Snowflakex.generate(maschine_id, sequence)
    next_state = { maschine_id, rem(sequence + 1, 1024) }
    { :reply, new_id, next_state }
  end
end
