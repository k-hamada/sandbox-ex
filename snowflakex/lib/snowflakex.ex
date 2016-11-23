defmodule Snowflakex do
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
end
