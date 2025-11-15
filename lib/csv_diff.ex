defmodule CsvDiff do
  @moduledoc """
  Provides an interface to the `csv-diff` Rust library, allowing for the diffing of CSV files.
  """

  alias CsvDiff.ByteRecordLineInfo

  @type diff() :: {:modify, %{delete: %ByteRecordLineInfo{}, add: %ByteRecordLineInfo{}, field_indices: [non_neg_integer()]}} |
             {:add, %ByteRecordLineInfo{}} |
             {:delete, %ByteRecordLineInfo{}}


  @doc """
  Diff two CSVs and return a list of differences in structured form.

  This corresponds to the `CsvByteDiffLocal` operation from the `csv-diff` Rust library.

  ## Examples

      iex> CsvDiff.diff("a,b,c\\n1,2,3\\n4,5,6", "a,b,c\\n1,2,3\\n4,5,6")
      []

      iex> CsvDiff.diff("a,b,c\\n1,2,3\\n4,5,6", "a,b,c\\n1,2,3\\n4,5,7")
      [
        {:modify, %{
          delete: %CsvDiff.ByteRecordLineInfo{line: 3, record: ["4", "5", "6"]},
          add: %CsvDiff.ByteRecordLineInfo{line: 3, record: ["4", "5", "7"]},
          field_indices: [2]
        }}
      ]

  """
  @spec diff(binary(), binary()) :: [diff()]
  def diff(a, b) do
    CsvDiff.Native.diff(a, b)
  end
end
