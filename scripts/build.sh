#!/usr/bin/env bash
#
# Builds the deployable Copilot Cowork plugin package.
#
# Output: dist/notion-cowork-connector.zip
#   - manifest.json MUST be at the root of the zip (Cowork/Teams requirement)
#   - includes the icons and the skills/ folder, nothing else
#
# Usage:  ./scripts/build.sh
#
set -euo pipefail

# Resolve repo root (parent of this script's directory) regardless of CWD.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$ROOT"

OUT_DIR="dist"
OUT_ZIP="$OUT_DIR/notion-cowork-connector.zip"

# Files/folders that go into the package (everything else is dev-only).
INCLUDE=(manifest.json color.png outline.png skills)

echo "==> Checking required files"
missing=0
for f in "${INCLUDE[@]}"; do
  if [[ ! -e "$f" ]]; then
    echo "    MISSING: $f"
    missing=1
  fi
done
[[ "$missing" -eq 0 ]] || { echo "ERROR: required files are missing."; exit 1; }

echo "==> Validating manifest.json"
python3 -c "import json,sys; json.load(open('manifest.json')); print('    manifest.json is valid JSON')"

echo "==> Validating SKILL.md frontmatter"
python3 - <<'PY'
import glob, sys
bad = False
for path in glob.glob("skills/*/SKILL.md"):
    text = open(path, encoding="utf-8").read()
    if not text.startswith("---"):
        print(f"    {path}: missing YAML frontmatter (must start with ---)"); bad = True; continue
    fm = text.split("---", 2)
    if len(fm) < 3:
        print(f"    {path}: unterminated frontmatter"); bad = True; continue
    head = fm[1]
    for key in ("name:", "description:"):
        if key not in head:
            print(f"    {path}: frontmatter missing '{key}'"); bad = True
print("    SKILL.md files OK" if not bad else "    SKILL.md problems found")
sys.exit(1 if bad else 0)
PY

echo "==> Packaging"
rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

# Build the zip deterministically with python so manifest.json lands at the root
# and no stray files (.git, dist, scripts, README) are included.
python3 - "$OUT_ZIP" "${INCLUDE[@]}" <<'PY'
import os, sys, zipfile
out = sys.argv[1]
items = sys.argv[2:]
with zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED) as z:
    for item in items:
        if os.path.isdir(item):
            for root, _, files in os.walk(item):
                for name in sorted(files):
                    full = os.path.join(root, name)
                    z.write(full, full)  # arcname keeps relative path, e.g. skills/.../SKILL.md
        else:
            z.write(item, item)          # manifest.json -> zip root
    print("    contents:")
    for n in z.namelist():
        pass
PY

echo "==> Built $OUT_ZIP"
echo "==> Zip contents:"
python3 -c "import zipfile,sys; [print('    ', n) for n in zipfile.ZipFile(sys.argv[1]).namelist()]" "$OUT_ZIP"

echo ""
echo "Done. Sideload $OUT_ZIP via:"
echo "  Microsoft 365 admin center -> Manage apps -> Upload custom app, OR"
echo "  Teams -> Apps -> Manage your apps -> Upload a customized app"
