defmodule MergePdf.Native do
  @moduledoc """
  Documentation for `MergePdf.Native`.
  """
  use Rustler, otp_app: :merge_pdf, crate: "mergepdf_native"

  def merge_binaries(_binaries), do: :erlang.nif_error(:nif_not_loaded)

  def merge_paths(_paths), do: :erlang.nif_error(:nif_not_loaded)
end
