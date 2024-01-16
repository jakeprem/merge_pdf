defmodule MergePdf do
  @moduledoc """
  Documentation for `MergePdf`.
  """

  @doc """
  Merge a list of PDF files found at the given paths.

  - `paths` - A list of paths to PDF files. Most likely must be fully expanded paths.
  """
  def merge_paths([]), do: {:error, "No paths given"}
  defdelegate merge_paths(paths), to: MergePdf.Native

  @doc """
  Merge a list of PDF binaries.

  - `binaries` - A list of binaries containing PDF data.
  """
  def merge_binaries([]), do: {:error, "No binaries given"}
  def merge_binaries([binary]), do: {:ok, binary}
  defdelegate merge_binaries(binaries), to: MergePdf.Native
end
