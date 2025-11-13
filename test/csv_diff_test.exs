defmodule CsvDiffTest do
  use ExUnit.Case
  doctest CsvDiff

  test "diff" do
    assert CsvDiff.diff("a,b,c\n1,2,3\n4,5,6", "a,b,c\n1,2,3\n4,5,6") == []
  end

  test "diff with modifications" do
    assert CsvDiff.diff("a,b,c\n1,2,3\n4,5,6", "a,b,c\n1,2,3\n4,5,7") == [
             modify: %{
               delete: %CsvDiff.ByteRecordLineInfo{line: 3, record: [~c"4", ~c"5", ~c"6"]},
               add: %CsvDiff.ByteRecordLineInfo{line: 3, record: [~c"4", ~c"5", ~c"7"]},
               field_indices: [2]
             }
           ]
  end
end
