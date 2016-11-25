defmodule Snowflakex.Snowflakex do
  use Bitwise

  @epoch 1288834974657
  @maschine_id_bits 10
  @sequence_bits 12

  def generate(maschine_id, sequence) do
    generate(timestamp(), maschine_id, sequence)
  end

  def generate(timestamp, maschine_id, sequence) do
    timestamp <<< (@maschine_id_bits + @sequence_bits)
    |||
    maschine_id <<< @maschine_id_bits
    |||
    sequence
  end

  def timestamp do
     timestamp_ms - @epoch
  end

  defp timestamp_ms do
    DateTime.utc_now()
    |> DateTime.to_unix(:milliseconds)
  end

  def inspect(id) do
    {:ok, p_timestamp} =
      id >>> (@maschine_id_bits + @sequence_bits)
      |> Kernel.+(@epoch)
      |> DateTime.from_unix(:milliseconds)
    p_maschine_id =
      id &&& generate(0, (1 <<< @maschine_id_bits + 1) -1, 0)
    p_sequence =
      id &&& generate(0, 0, (1 <<< @sequence_bits + 1) -1)

    "timestamp: #{p_timestamp}\nmaschine_id: #{p_maschine_id}\nsequence: #{p_sequence}"
    |> IO.puts
  end
end
