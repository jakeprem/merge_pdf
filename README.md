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
    {:merge_pdf, "~> 0.5.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/merge_pdf>.

## Development

To build the NIF from source (instead of using precompiled binaries):

```bash
# Set environment variable to force local build
export MERGE_PDF_BUILD=true
mix deps.get
mix compile
```

Requires Rust toolchain installed via [rustup](https://rustup.rs/).

## Release Process (Maintainers)

This project uses [RustlerPrecompiled](https://hexdocs.pm/rustler_precompiled) with GitHub Actions to build binaries for 9 platforms.

### Prerequisites

1. Authenticate with Hex.pm: `mix hex.user auth`
2. Ensure GitHub Actions has write permissions (Settings > Actions > General)

### Steps

1. **Bump version** in `mix.exs` and `native/mergepdf_native/Cargo.toml`:
   ```bash
   just bump-version X.Y.Z
   ```

2. **Commit and tag**:
   ```bash
   just tag X.Y.Z
   just push-release
   ```

3. **Wait for CI** - All 9 platform builds must complete on [GitHub Actions](https://github.com/jakeprem/merge_pdf/actions)

4. **Generate checksums** (after CI completes):
   ```bash
   just download-checksums
   ```

5. **Verify and publish**:
   ```bash
   just verify-package
   just publish
   ```

### Justfile Commands

- `just version` - Show current version
- `just release X.Y.Z` - Interactive release guide
- `just --list` - List all commands
