defmodule Filtration.EntryView do
  use Filtration.Web, :view

  def format_datetime(dt) do
    dt
    |> Calendar.DateTime.shift_zone!("Japan")
    |> Calendar.Strftime.strftime!("%m/%d %H:%M")
  end
end
