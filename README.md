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

This project uses [RustlerPrecompiled](https://hexdocs.pm/rustler_precompiled) to distribute precompiled native binaries. For development, you'll build the Rust NIF from source.

### Prerequisites

- Elixir 1.15+
- Rust toolchain via [rustup](https://rustup.rs/)
- [just](https://github.com/casey/just) command runner

### First-Time Setup

```bash
just setup
```

This cleans any stale artifacts and builds the NIF from source. Run this when:
- You first clone the repo
- You switch branches with native code changes
- You get precompilation-related errors

### Day-to-Day Development

```bash
just build    # Rebuild NIF after Rust changes
just test     # Run tests
```

All development commands use `MERGE_PDF_BUILD=true` internally to force building from source rather than downloading precompiled binaries.

## Release Process (Maintainers)

This project builds precompiled binaries for 9 platforms via GitHub Actions. The release process has two phases: **before CI** (local verification) and **after CI** (publishing).

### Prerequisites

1. Authenticate with Hex.pm: `mix hex.user auth`
2. Ensure GitHub Actions has write permissions (Settings > Actions > General)

### Phase 1: Before CI (Local Verification)

These steps verify everything works before creating a release.

```bash
# 1. Bump version in mix.exs and Cargo.toml
just bump-version X.Y.Z

# 2. Verify everything builds and tests pass
#    (This does a clean build from source - catches Rust compilation errors)
just verify-local

# 3. Review and commit the version bump
git diff
git add -p
git commit

# 4. Create the git tag
just tag X.Y.Z

# 5. Push to GitHub (triggers CI to build all 9 platform binaries)
just push-release
```

At this point, wait for [GitHub Actions](https://github.com/jakeprem/merge_pdf/actions) to complete. All 9 platform builds must succeed.

### Phase 2: After CI (Publishing)

Once CI completes successfully, the precompiled binaries are attached to the GitHub release. Now generate checksums and publish.

```bash
# 6. Download checksums from the GitHub release
#    (This verifies all 9 binaries are downloadable)
just download-checksums

# 7. Inspect the hex package contents
just verify-package

# 8. Publish to hex.pm
just publish
```

### Justfile Commands Reference

**Development:**
- `just setup` - First-time setup, builds NIF from source
- `just build` - Rebuild NIF from source
- `just test` - Run tests

**Pre-release:**
- `just verify-local` - Clean build + tests (run before tagging)
- `just bump-version X.Y.Z` - Update version numbers

**Release:**
- `just tag X.Y.Z` - Create git tag
- `just push-release` - Push to GitHub (triggers CI)
- `just download-checksums` - Download checksums after CI
- `just verify-package` - Inspect hex package
- `just publish` - Publish to hex.pm

**Utilities:**
- `just version` - Show current version
- `just clean` - Remove build artifacts
- `just --list` - List all commands
