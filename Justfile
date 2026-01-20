# MergePdf Release Automation

# Default recipe
default:
    @just --list

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

# Create release commit and tag
tag version:
    git add -A
    git commit -m "Release v{{version}}"
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
    mix hex.build --unpack
    @echo "Check the unpacked directory for correct contents"

# Publish to hex.pm
publish:
    mix hex.publish

# Full release workflow (interactive)
release version:
    @echo "=== Release Workflow for v{{version}} ==="
    @echo ""
    @echo "Step 1: Bumping version..."
    just bump-version {{version}}
    @echo ""
    @echo "Step 2: Review changes, then run:"
    @echo "  just tag {{version}}"
    @echo "  just push-release"
    @echo ""
    @echo "Step 3: Wait for GitHub Actions to complete"
    @echo "  https://github.com/jakeprem/merge_pdf/actions"
    @echo ""
    @echo "Step 4: After CI completes, run:"
    @echo "  just download-checksums"
    @echo ""
    @echo "Step 5: Verify package:"
    @echo "  just verify-package"
    @echo ""
    @echo "Step 6: Publish:"
    @echo "  just publish"

# Check current version
version:
    @grep '@version' mix.exs | head -1
    @grep '^version' native/mergepdf_native/Cargo.toml

# Clean build artifacts
clean:
    rm -rf _build deps merge_pdf-*
    rm -f checksum-*.exs
