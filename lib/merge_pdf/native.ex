defmodule MergePdf.Native do
  @moduledoc """
  Documentation for `MergePdf.Native`.
  """
  version = Mix.Project.config()[:version]

  use RustlerPrecompiled,
    otp_app: :merge_pdf,
    crate: "mergepdf_native",
    base_url: "https://github.com/jakeprem/merge_pdf/releases/download/v#{version}",
    force_build: System.get_env("MERGE_PDF_BUILD") in ["1", "true"],
    version: version,
    targets: [
      "aarch64-apple-darwin",
      "aarch64-unknown-linux-gnu",
      "arm-unknown-linux-gnueabihf",
      "riscv64gc-unknown-linux-gnu",
      "x86_64-apple-darwin",
      "x86_64-pc-windows-gnu",
      "x86_64-pc-windows-msvc",
      "x86_64-unknown-linux-gnu",
      "x86_64-unknown-linux-musl"
    ]

  def merge_binaries(_binaries), do: :erlang.nif_error(:nif_not_loaded)

  def merge_paths(_paths), do: :erlang.nif_error(:nif_not_loaded)
end
