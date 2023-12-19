defmodule MergePdf do
  @moduledoc """
  Documentation for `MergePdf`.
  """
  def merge_paths([]), do: {:error, "No paths given"}
  defdelegate merge_paths(paths), to: MergePdf.Native

  def merge_binaries([]), do: {:error, "No binaries given"}
  defdelegate merge_binaries(paths), to: MergePdf.Native
end
