#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
cd "${repo_root}"

tmpdir="$(mktemp -d)"
cleanup() {
  rm -rf "${tmpdir}"
}
trap cleanup EXIT

npm install \
  --silent \
  --no-save \
  --prefix "${tmpdir}" \
  prettier

prettier_bin="${tmpdir}/node_modules/.bin/prettier"

files=()
while IFS= read -r -d '' file; do
  case "${file}" in
    */templates/*)
      continue
      ;;
  esac
  files+=("${file}")
done < <(
  git ls-files -z -- \
    '*.json' \
    '*.json5' \
    '*.md' \
    '*.yaml' \
    '*.yml' \
    '*.js' \
    '*.cjs' \
    '*.mjs' \
    '*.ts' \
    '*.tsx' \
    '*.css' \
    '*.scss' \
    '*.html'
)

if ((${#files[@]} == 0)); then
  exit 0
fi

"${prettier_bin}" \
  --cache \
  --log-level warn \
  --ignore-unknown \
  --prose-wrap preserve \
  --write \
  "${files[@]}"
