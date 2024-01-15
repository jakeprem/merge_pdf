defmodule MergePdf.MixProject do
  use Mix.Project

  # Used by CI/CD, so make sure this is updated
  @version "0.3.0"
  @source_url "https://github.com/jakeprem/merge_pdf"
  @dev? String.ends_with?(@version, "-dev")
  @force_build? System.get_env("MERGE_PDF_BUILD") in ["1", "true"]

  def project do
    [
      app: :merge_pdf,
      name: "Merge PDF",
      description: "Merge PDFs using lopdf via Rustler",
      version: @version,
      elixir: "~> 1.15",
      package: package(),
      deps: deps(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      files: [
        "lib",
        "native",
        "checksum-*.exs",
        "mix.exs"
      ],
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:rustler_precompiled, "~> 0.7"},
      {:rustler, "~> 0.30.0", optional: not (@dev? or @force_build?)},

      # Dev
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      source_ref: "v#{@version}",
      source_url: @source_url
    ]
  end
end
