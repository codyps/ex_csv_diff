defmodule CsvDiff do
  @moduledoc """
  Provides an interface to the `csv-diff` Rust library, allowing for the diffing of CSV files.
  """

  @doc """
  Diff two CSV strings and return a list of differences in structured form.

  This corresponds to the `CsvByteDiffLocal` operation from the `csv-diff` Rust library.

  ## Examples

      iex> CsvDiff.diff("a,b,c\\n1,2,3\\n4,5,6", "a,b,c\\n1,2,3\\n4,5,6")
      []

      iex> CsvDiff.diff("a,b,c\\n1,2,3\\n4,5,6", "a,b,c\\n1,2,3\\n4,5,7")
      [
        {:modify, %{
          delete: %CsvDiff.ByteRecordLineInfo{line: 3, record: [~c"4", ~c"5", ~c"6"]},
          add: %CsvDiff.ByteRecordLineInfo{line: 3, record: [~c"4", ~c"5", ~c"7"]},
          field_indices: [2]
        }}
      ]

  """
  def diff(a, b) do
    CsvDiff.Native.diff(a, b)
  end
end
