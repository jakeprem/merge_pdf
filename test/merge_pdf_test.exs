defmodule MergePdfTest do
  use ExUnit.Case
  doctest MergePdf

  describe "merge_paths/1" do
    test "returns an error when no paths are given" do
      assert {:error, "No paths given"} = MergePdf.merge_paths([])
    end
  end

  describe "merge_binaries/1" do
    test "returns an error when no binaries are given" do
      assert {:error, "No binaries given"} = MergePdf.merge_binaries([])
    end

    test "returns the binary when only one binary is given" do
      assert {:ok, <<1, 2, 3>>} = MergePdf.merge_binaries([<<1, 2, 3>>])
    end
  end

  describe "merge_binaries/1 with real PDFs" do
    test "merges two PDFs" do
      pdf = File.read!("test/fixtures/test.pdf")
      assert {:ok, merged} = MergePdf.merge_binaries([pdf, pdf])
      assert <<"%PDF", _rest::binary>> = merged
    end
  end

  describe "merge_paths/1 with real PDFs" do
    test "merges two PDFs by path" do
      path = "test/fixtures/test.pdf"
      assert {:ok, merged} = MergePdf.merge_paths([path, path])
      assert <<"%PDF", _rest::binary>> = merged
    end
  end
end
