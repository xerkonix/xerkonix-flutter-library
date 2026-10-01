#!/usr/bin/env python3
"""Build the CanvasKit face: Pretendard Variable, KS X 1001 subset, wght 400–600.

Owner: xerkonix-flutter-library
Input: Pretendard release `public/variable/PretendardVariable.ttf` (1.3.9, OFL 1.1)
Output (generated — do not hand-edit):
  xerkonix-design-system/lib/fonts/pretendard/PretendardVariable-ksx1001-w400-600.ttf
  xerkonix-design-system/lib/fonts/pretendard/SOURCE.txt
  xerkonix-design-system/lib/fonts/pretendard/LICENSE.txt   (copied from the release)

Glyph set: KS X 1001 Hangul syllables (2,350) + Hangul compatibility jamo +
Basic Latin + Latin-1 Supplement + general punctuation / currency / arrows /
a few geometric shapes + CJK punctuation + fullwidth forms. Layout features
kept: kern liga calt ccmp locl mark mkmk rlig rvrn. TrueType hinting dropped
(CanvasKit does not use it). The wght axis is instanced to 400–600 so the
file covers 400 · 500 · 600 (and the CSS 450 / 550 in between) and stays
under 1 MB.

  python3 tools/build_pretendard_subset.py --write --source <PretendardVariable.ttf> --license <LICENSE.txt>
  python3 tools/build_pretendard_subset.py --check     # sha256 of the committed output vs SOURCE.txt (no fonttools needed)

`--write` needs fonttools (`pip install fonttools`).
"""
from __future__ import annotations

import argparse
import hashlib
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
LIB_ROOT = HERE.parent
OUT_DIR = LIB_ROOT / "xerkonix-design-system" / "lib" / "fonts" / "pretendard"
OUT_NAME = "PretendardVariable-ksx1001-w400-600.ttf"
OUT = OUT_DIR / OUT_NAME
SOURCE_TXT = OUT_DIR / "SOURCE.txt"
LICENSE_TXT = OUT_DIR / "LICENSE.txt"
RELEASE = "1.3.9"
RELEASE_URL = "https://github.com/orioncactus/pretendard/releases/tag/v1.3.9"
WGHT_MIN, WGHT_MAX = 400, 600
FEATURES = ("kern", "liga", "calt", "ccmp", "locl", "mark", "mkmk", "rlig", "rvrn")
# Besides the 2,350 KS X 1001 syllables.
EXTRA_RANGES = (
    (0x0020, 0x007E),  # Basic Latin
    (0x00A0, 0x00FF),  # Latin-1 Supplement
    (0x02C6, 0x02C7), (0x02DC, 0x02DC),
    (0x2010, 0x2027), (0x2030, 0x205E),  # general punctuation
    (0x20A9, 0x20A9), (0x20AC, 0x20AC),  # ₩ €
    (0x2113, 0x2113), (0x2116, 0x2116), (0x2122, 0x2122),
    (0x2190, 0x2199),  # arrows
    (0x2212, 0x2212), (0x2215, 0x2215), (0x221E, 0x221E),
    (0x2260, 0x2260), (0x2264, 0x2265),
    (0x25A0, 0x25A1), (0x25B2, 0x25B3), (0x25BC, 0x25BD), (0x25C6, 0x25C7),
    (0x25CB, 0x25CB), (0x25CF, 0x25CF), (0x2605, 0x2606),
    (0x3000, 0x3003), (0x3008, 0x3011),  # CJK punctuation
    (0x3131, 0x318E),  # Hangul compatibility jamo
    (0xFF01, 0xFF5E),  # fullwidth forms
)


def ksx1001_hangul() -> list[int]:
    out = []
    for cp in range(0xAC00, 0xD7A4):
        b = chr(cp).encode("cp949")
        if len(b) == 2 and 0xB0 <= b[0] <= 0xC8 and 0xA1 <= b[1] <= 0xFE:
            out.append(cp)
    assert len(out) == 2350, len(out)
    return out


def codepoints() -> list[int]:
    cps = set(ksx1001_hangul())
    for a, b in EXTRA_RANGES:
        cps.update(range(a, b + 1))
    return sorted(cps)


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def write(source: Path, license_path: Path) -> int:
    from fontTools import subset
    from fontTools.ttLib import TTFont
    from fontTools.varLib import instancer

    font = TTFont(str(source))
    options = subset.Options()
    options.layout_features = list(FEATURES)
    options.hinting = False
    options.notdef_outline = True
    options.name_IDs = ["*"]
    subsetter = subset.Subsetter(options=options)
    subsetter.populate(unicodes=codepoints())
    subsetter.subset(font)
    font = instancer.instantiateVariableFont(font, {"wght": (WGHT_MIN, WGHT_MAX)})
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    font.save(str(OUT))
    LICENSE_TXT.write_bytes(license_path.read_bytes())
    cps = codepoints()
    SOURCE_TXT.write_text(
        "\n".join(
            [
                "Pretendard Variable — KS X 1001 subset, wght 400–600 (generated).",
                "",
                f"Release: Pretendard {RELEASE} ({RELEASE_URL})",
                "Input: public/variable/PretendardVariable.ttf",
                f"Input sha256: {sha256_file(source)}",
                "License: SIL OFL 1.1 (LICENSE.txt = release LICENSE.txt)",
                "Generator: tools/build_pretendard_subset.py",
                "",
                f"Codepoints: {len(cps)} (KS X 1001 Hangul 2,350 + Latin / digits / symbols)",
                f"wght axis: {WGHT_MIN}–{WGHT_MAX} (covers 400 · 500 · 600; CSS 450 / 550 via FontVariation)",
                f"Layout features: {' '.join(FEATURES)}; hinting dropped",
                "",
                f"{OUT_NAME}",
                f"bytes: {OUT.stat().st_size}",
                f"sha256: {sha256_file(OUT)}",
                "",
                "Flutter registers it as family \"Pretendard\" via FontLoader",
                "(tactile_fonts.dart). Consume copies: tools/sync_tactile_fonts.py.",
            ]
        )
        + "\n",
        encoding="utf-8",
    )
    print(f"wrote {OUT} ({OUT.stat().st_size} bytes)")
    return check()


def check() -> int:
    if not OUT.is_file() or not SOURCE_TXT.is_file() or not LICENSE_TXT.is_file():
        print("FAIL pretendard subset output or SOURCE.txt / LICENSE.txt missing", file=sys.stderr)
        return 1
    recorded = {}
    for line in SOURCE_TXT.read_text(encoding="utf-8").splitlines():
        if ":" in line:
            k, _, v = line.partition(":")
            recorded[k.strip()] = v.strip()
    errors = 0
    if recorded.get("bytes") != str(OUT.stat().st_size):
        print(f"FAIL bytes {OUT.stat().st_size} ≠ SOURCE.txt {recorded.get('bytes')}", file=sys.stderr)
        errors += 1
    if recorded.get("sha256") != sha256_file(OUT):
        print("FAIL sha256 drift — rerun --write", file=sys.stderr)
        errors += 1
    if OUT.stat().st_size > 1_000_000:
        print(f"FAIL {OUT_NAME} is over 1 MB ({OUT.stat().st_size})", file=sys.stderr)
        errors += 1
    if "OFL" not in LICENSE_TXT.read_text(encoding="utf-8", errors="replace"):
        print("FAIL LICENSE.txt is not the OFL text", file=sys.stderr)
        errors += 1
    print("pretendard subset OK" if errors == 0 else f"{errors} problems")
    return 0 if errors == 0 else 1


def main() -> int:
    p = argparse.ArgumentParser()
    g = p.add_mutually_exclusive_group(required=True)
    g.add_argument("--write", action="store_true")
    g.add_argument("--check", action="store_true")
    p.add_argument("--source", type=Path, help="PretendardVariable.ttf from the release")
    p.add_argument("--license", type=Path, help="LICENSE.txt from the release")
    args = p.parse_args()
    if args.write:
        if not args.source or not args.license:
            p.error("--write needs --source and --license")
        return write(args.source, args.license)
    return check()


if __name__ == "__main__":
    raise SystemExit(main())
