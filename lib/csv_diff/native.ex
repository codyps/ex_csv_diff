defmodule CsvDiff.ByteRecordLineInfo do
  defstruct [:line, :record]
end

defmodule CsvDiff.Native do
  version = Mix.Project.config()[:version]

  use RustlerPrecompiled,
    otp_app: :csv_diff,
    crate: "nativecsvdiff",
    base_url:
      "https://github.com/codyps/ex_csv_diff/releases/download/v#{version}",
    force_build: System.get_env("RUSTLER_PRECOMPILATION_FORCE_BUILD") in ["1", "true"],
    version: version

  def diff(_a, _b), do: :erlang.nif_error(:nif_not_loaded)
end
