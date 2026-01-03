set shell := ['uv', 'run', '--frozen', 'bash', '-euxo', 'pipefail', '-c']
set unstable
set positional-arguments

project := "confide"
package := "confide"
module := "confide"
pnpm := "pnpm exec"
test_pypi_index := "https://test.pypi.org/legacy/"

# List available recipes
default:
  @just --list

# Build distribution package
[script]
build: clean
  mkdir -p dist/RequirementsWriting/styles
  echo "StylesPath = styles" > dist/RequirementsWriting/.vale.ini
  cp -r styles/RequirementsWriting dist/RequirementsWriting/styles
  cd dist && zip -r ../RequirementsWriting.zip RequirementsWriting

# Clean up generated files
clean:
  rm -rf dist

# Format code
format:
  codespell -w
  {{pnpm}} biome format --write .

# Fix code issues
fix:
  biome format --write .
  biome check --write .

# Fix code issues including unsafe fixes
fix-unsafe:
  biome check --write --unsafe

# Run all linters
lint: lint-markdown lint-prose lint-spelling lint-web lint-yaml

# Lint Markdown files
lint-markdown:
  {{pnpm}} markdownlint-cli2 "**/*.md"

# Lint prose in Markdown files
lint-prose:
  vale README.md

# Check spelling
lint-spelling:
  codespell

# Lint web files (CSS, HTML, JS, JSON)
lint-web:
  {{pnpm}} biome check .

# Lint YAML files
lint-yaml:
  yamllint --strict .

# Install all dependencies (Python + Node.js)
install: install-node install-python

# Install only Node.js dependencies
install-node:
  #!/usr/bin/env bash
  pnpm install --frozen-lockfile

# Install only Python dependencies
install-python:
  #!/usr/bin/env bash
  uv sync --frozen

# Run pre-commit hooks on changed files
prek:
  prek

# Run pre-commit hooks on all files
prek-all:
  prek run --all-files

# Install pre-commit hooks
prek-install:
  prek install

# Run command
run *args:
  "$@"

# Run Node.js
run-node *args:
  {{pnpm}} "$@"

# Run Python
run-python *args:
  python "$@"

# Sync Vale styles and dictionaries
vale-sync:
  vale sync

# Test RequirementsWriting Vale styles (expects warnings/errors)
test:
  #!/usr/bin/env bash
  cd tests && vale . > /tmp/vale-output.txt 2>&1 || true
  if grep -q "0 errors.*0 warnings" /tmp/vale-output.txt; then
    echo "ERROR: Expected Vale to report warnings/errors but got none"
    cat /tmp/vale-output.txt
    exit 1
  fi
  echo "Vale styles are working correctly:"
  tail -1 /tmp/vale-output.txt
