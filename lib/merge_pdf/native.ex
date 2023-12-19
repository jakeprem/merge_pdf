defmodule MergePdf.Native do
  @moduledoc """
  Documentation for `MergePdf.Native`.
  """
  version = Mix.Project.config()[:version]

  use RustlerPrecompiled,
    otp_app: :merge_pdf,
    crate: "mergepdf_native",
    base_url: "https://github.com/jakeprem/merge_pdf/releases/download/v#{version}",
    force_build: System.get_env("RUSTLER_PRECOMPILATION_MERGE_PDF_BUILD") in ["1", "true"],
    version: version

  def merge_binaries(_binaries), do: :erlang.nif_error(:nif_not_loaded)

  def merge_paths(_paths), do: :erlang.nif_error(:nif_not_loaded)
end
