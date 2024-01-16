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
end
