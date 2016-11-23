defmodule Snowflakex.Server do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, {1, 0}, name: __MODULE__)
  end

  def new_id do
    GenServer.call __MODULE__, :new_id
  end

  def handle_call(:new_id, _from, { maschine_id, sequence }) do
    new_id = Snowflakex.generate(maschine_id, sequence)
    next_state = {maschine_id, rem(sequence + 1, 1024) }
    { :reply, new_id, next_state }
  end
end
