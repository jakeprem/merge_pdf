# MergePdf

A PDF merging library built using Rust and Rustler, with precompiled binaries.

- Basically wraps the [Merge PDF example](https://github.com/J-F-Liu/lopdf) from [lopdf](https://github.com/J-F-Liu/lopdf) using Rustler
- Can merge pdfs from binaries or paths
- Uses RustlerPrecompiled so every dev in a project using this library doesn't need Rust installed on their machine.

## Installation

The package can be installed
by adding `merge_pdf` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:merge_pdf, "~> 0.3.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/merge_pdf>.
