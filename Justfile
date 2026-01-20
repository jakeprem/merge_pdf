# MergePdf Development & Release Automation
#
# DEVELOPMENT WORKFLOW (new contributors):
#   just setup          # First-time setup, builds NIF from source
#   just build          # Rebuild NIF from source after changes
#   just test           # Run tests
#
# RELEASE WORKFLOW (maintainers):
#   just bump-version X.Y.Z   # 1. Update version numbers
#   just verify-local         # 2. Verify everything builds and tests pass
#   # review and commit your changes
#   just tag X.Y.Z            # 3. Create git tag
#   just push-release         # 4. Push to GitHub (triggers CI)
#   # ... wait for CI to complete ...
#   just download-checksums   # 5. Download checksums from release
#   just verify-package       # 6. Verify hex package contents
#   just publish              # 7. Publish to hex.pm

# Default recipe
default:
    @just --list

# =============================================================================
# DEVELOPMENT COMMANDS
# =============================================================================

# First-time setup for new contributors (builds NIF from source)
setup:
    @echo "Setting up development environment..."
    @echo "This will build the Rust NIF from source (requires Rust toolchain)"
    rm -rf _build deps
    MERGE_PDF_BUILD=true mix deps.get
    MERGE_PDF_BUILD=true mix compile
    @echo ""
    @echo "Setup complete! You can now run: just test"

# Build NIF from source
build:
    MERGE_PDF_BUILD=true mix compile

# Run tests (builds from source if needed)
test:
    MERGE_PDF_BUILD=true mix test

# =============================================================================
# PRE-RELEASE VERIFICATION
# =============================================================================

# Verify local build before release (clean build + tests)
verify-local:
    @echo "=== Pre-release verification ==="
    @echo "Cleaning build artifacts..."
    rm -rf _build deps
    @echo ""
    @echo "Building from source..."
    MERGE_PDF_BUILD=true mix deps.get
    MERGE_PDF_BUILD=true mix compile
    @echo ""
    @echo "Running tests..."
    MERGE_PDF_BUILD=true mix test
    @echo ""
    @echo "=== Verification passed ==="
    @echo "You can now commit and tag the release."

# =============================================================================
# RELEASE COMMANDS
# =============================================================================

# Bump version in mix.exs and Cargo.toml (Linux)
[linux]
bump-version version:
    @echo "Bumping version to {{version}}"
    sed -i 's/@version "[^"]*"/@version "{{version}}"/' mix.exs
    sed -i 's/^version = "[^"]*"/version = "{{version}}"/' native/mergepdf_native/Cargo.toml
    @echo "Version bumped. Please verify changes with: git diff"

# Bump version in mix.exs and Cargo.toml (macOS)
[macos]
bump-version version:
    @echo "Bumping version to {{version}}"
    sed -i '' 's/@version "[^"]*"/@version "{{version}}"/' mix.exs
    sed -i '' 's/^version = "[^"]*"/version = "{{version}}"/' native/mergepdf_native/Cargo.toml
    @echo "Version bumped. Please verify changes with: git diff"

# Create release tag (requires clean working directory)
tag version:
    #!/usr/bin/env bash
    set -euo pipefail

    # Check for any uncommitted changes (staged or unstaged)
    if [ -n "$(git status --porcelain)" ]; then
        echo "Error: You have uncommitted changes:"
        git status --short
        echo ""
        echo "Please commit your changes first, then run this command again."
        echo "Or use 'just tag-force {{version}}' to tag the current commit anyway"
        echo "(uncommitted changes will NOT be included in the tagged commit)."
        exit 1
    fi

    git tag "v{{version}}"
    echo "Created tag v{{version}}. Push with: just push-release"

# Create release tag, ignoring uncommitted changes
tag-force version:
    git tag "v{{version}}"
    @echo "Created tag v{{version}}. Push with: just push-release"

# Push release to GitHub (triggers CI build)
push-release:
    git push origin master --tags

# Download checksums after CI completes
download-checksums:
    mix rustler_precompiled.download MergePdf.Native --all --print

# Verify hex package contents
verify-package:
    #!/usr/bin/env bash
    set -euo pipefail

    echo "Building hex package..."
    mix hex.build --unpack

    # Find the unpacked directory
    PKG_DIR=$(ls -d merge_pdf-* 2>/dev/null | head -1)
    if [ -z "$PKG_DIR" ]; then
        echo "Error: No unpacked package directory found"
        exit 1
    fi

    echo ""
    echo "=== Package contents ==="
    find "$PKG_DIR" -type f | sort
    echo ""

    echo "=== Verifying required files ==="
    MISSING=0

    # Check for checksum file
    if ls "$PKG_DIR"/checksum-*.exs 1>/dev/null 2>&1; then
        echo "✓ Checksum file found"
    else
        echo "✗ ERROR: No checksum file (checksum-*.exs) - did you run 'just download-checksums'?"
        MISSING=1
    fi

    # Check for mix.exs
    if [ -f "$PKG_DIR/mix.exs" ]; then
        echo "✓ mix.exs found"
    else
        echo "✗ ERROR: mix.exs missing"
        MISSING=1
    fi

    # Check for lib directory
    if [ -d "$PKG_DIR/lib" ]; then
        echo "✓ lib/ directory found"
    else
        echo "✗ ERROR: lib/ directory missing"
        MISSING=1
    fi

    # Check for native directory
    if [ -d "$PKG_DIR/native" ]; then
        echo "✓ native/ directory found"
    else
        echo "✗ ERROR: native/ directory missing"
        MISSING=1
    fi

    echo ""
    if [ $MISSING -eq 1 ]; then
        echo "=== VERIFICATION FAILED ==="
        exit 1
    else
        echo "=== VERIFICATION PASSED ==="
        echo "Package is ready to publish."
    fi

# Publish to hex.pm (fails on any uncommitted changes except checksum file)
publish:
    #!/usr/bin/env bash
    set -euo pipefail

    # Check for uncommitted changes to tracked files (ignore untracked checksum file)
    if [ -n "$(git status --porcelain | grep -v '^?? checksum-')" ]; then
        echo "Error: You have uncommitted changes to tracked files:"
        git status --short | grep -v '^?? checksum-'
        echo ""
        echo "Commit or stash changes before publishing."
        exit 1
    fi

    # Verify checksum file exists
    if ! ls checksum-*.exs 1>/dev/null 2>&1; then
        echo "Error: No checksum file found. Run 'just download-checksums' first."
        exit 1
    fi

    mix hex.publish

# Check current version
version:
    @grep '@version' mix.exs | head -1
    @grep '^version' native/mergepdf_native/Cargo.toml

# Clean build artifacts
clean:
    rm -rf _build deps merge_pdf-*
    rm -f checksum-*.exs
