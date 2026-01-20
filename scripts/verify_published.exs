# Usage: elixir scripts/verify_published.exs [version]
# Defaults to latest if no version specified

version =
  case System.argv() do
    [v] -> "== #{v}"
    [] -> ">= 0.0.0"
  end

Mix.install([{:merge_pdf, version}])

IO.puts("Installed merge_pdf")

# Paths to test fixtures
test_pdf_path = Path.join([__DIR__, "..", "test", "fixtures", "test.pdf"])
test_pdf = File.read!(test_pdf_path)

# Test merge_binaries
IO.puts("Testing merge_binaries...")
{:ok, merged} = MergePdf.merge_binaries([test_pdf, test_pdf])
<<"%PDF", _rest::binary>> = merged
IO.puts("  ✓ merge_binaries works")

# Test merge_paths
IO.puts("Testing merge_paths...")
{:ok, merged} = MergePdf.merge_paths([test_pdf_path, test_pdf_path])
<<"%PDF", _rest::binary>> = merged
IO.puts("  ✓ merge_paths works")

IO.puts("")
IO.puts("Success! Package works correctly.")
