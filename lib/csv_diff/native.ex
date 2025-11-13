defmodule CsvDiff.ByteRecordLineInfo do
  defstruct [:line, :record]
end

defmodule CsvDiff.Native do
  use Rustler, otp_app: :csv_diff, crate: "nativecsvdiff"

  def diff(_a, _b), do: :erlang.nif_error(:nif_not_loaded)
end
