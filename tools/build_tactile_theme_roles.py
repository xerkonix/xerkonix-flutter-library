#!/usr/bin/env python3
"""Generate / check Material-slot → TACTILE CSS-var mapping.

Owner: xerkonix-flutter-library
Source: DS tactile/tokens.css (do not hand-edit product _tokens.dart).

  python3 tools/build_tactile_theme_roles.py --write [--tokens PATH]
  python3 tools/build_tactile_theme_roles.py --check [--tokens PATH]
"""
from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
LIB_ROOT = HERE.parent
OUT = HERE / "tactile_theme_roles.json"
DART = LIB_ROOT / "xerkonix-design-system/lib/src/tactile/tactile_tokens.dart"

# ThemeData / chrome slot → CSS custom property. Hex is not invented here.
ROLES: dict[str, str] = {
    "scaffoldBackgroundColor": "--canvas",
    "canvasColor": "--canvas",
    "colorScheme.primary": "--primary-base",
    "colorScheme.onPrimary": "--primary-text",
    "colorScheme.secondary": "--ink",
    "colorScheme.surface": "--surface",
    "colorScheme.onSurface": "--ink",
    "colorScheme.outline": "--line",
    "colorScheme.inverseSurface": "--overlay-fill",
    "appBarTheme.backgroundColor": "--header-fill",
    "cardTheme.color": "--panel-fill",
    "dialogTheme.backgroundColor": "--overlay-fill",
    "popupMenuTheme.color": "--overlay-fill",
    "bottomSheetTheme.backgroundColor": "--overlay-fill",
    "drawerTheme.backgroundColor": "--overlay-fill",
    "snackBarTheme.backgroundColor": "--overlay-fill",
    "tabBarTheme.indicatorColor": "--ice",
    "switchTheme.trackSelected": "--control-on",
    "switchTheme.trackUnselected": "--control-track",
    "checkboxTheme.fillSelected": "--control-on",
    "inputFill": "--input-fill",
    "chrome.faint": "--faint",
    "chrome.muted": "--muted",
}

DART_FIELDS = {
    "--canvas": "canvas",
    "--surface": "surface",
    "--ink": "ink",
    "--muted": "muted",
    "--faint": "faint",
    "--line": "line",
    "--ice": "ice",
    "--accent": "accent",
    "--panel-fill": "panelFill",
    "--overlay-fill": "overlayFill",
    "--header-fill": "headerFill",
    "--primary-base": "primaryBase",
    "--primary-text": "primaryText",
    "--control-on": "controlOn",
    "--control-track": "controlTrack",
    "--input-fill": "inputFill",
}


def find_tokens(explicit: str | None) -> Path | None:
    if explicit:
        path = Path(explicit)
        return path if path.is_file() else None
    here = LIB_ROOT
    candidates = [
        here.parent / "xerkonix-design-system" / "tactile" / "tokens.css",
        Path("/tmp/xerkonix-ds-20260920/C/official-copy/xerkonix-design-system/tactile/tokens.css"),
    ]
    for path in candidates:
        if path.is_file():
            return path
    return None


def _block(css: str, header: str) -> str:
    i = css.find(header)
    if i < 0:
        raise SystemExit(f"missing block {header}")
    start = css.find("{", i)
    end = css.find("}", start)
    return css[start + 1 : end]


def _decls(block: str) -> dict[str, str]:
    out: dict[str, str] = {}
    for m in re.finditer(r"(--[\w-]+)\s*:\s*([^;]+)", block):
        out[m.group(1)] = m.group(2).strip()
    return out


def _parse_color(raw: str) -> str | None:
    hex6 = re.fullmatch(r"#([0-9a-fA-F]{6})", raw)
    if hex6:
        return f"0xFF{hex6.group(1).upper()}"
    rgba = re.fullmatch(
        r"rgba\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*([0-9.]+)\s*\)", raw
    )
    if rgba:
        a = round(float(rgba.group(4)) * 255)
        return "0x" + f"{a:02X}{int(rgba.group(1)):02X}{int(rgba.group(2)):02X}{int(rgba.group(3)):02X}"
    rgb = re.fullmatch(r"rgb\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)", raw)
    if rgb:
        return "0xFF" + f"{int(rgb.group(1)):02X}{int(rgb.group(2)):02X}{int(rgb.group(3)):02X}"
    return None


def extract(css_path: Path) -> dict:
    css = css_path.read_text(encoding="utf-8")
    light = _decls(_block(css, ":root"))
    dark = dict(light)
    dark.update(_decls(_block(css, '[data-theme="dark"]')))
    roles = {}
    for slot, var in ROLES.items():
        lv = _parse_color(light[var]) if var in light else None
        dv = _parse_color(dark[var]) if var in dark else None
        roles[slot] = {"css": var, "light": lv, "dark": dv}
    return {
        "kind": "xerkonix-tactile-theme-roles",
        "owner": "xerkonix-flutter-library",
        "source": "tactile/tokens.css",
        "generator": "tools/build_tactile_theme_roles.py",
        "not": "product _tokens.dart / tokens.css v4 ledger",
        "roles": roles,
    }


def dart_hexes(kind: str) -> dict[str, str]:
    text = DART.read_text(encoding="utf-8")
    marker = "static const XkTactileTokens light" if kind == "light" else "static const XkTactileTokens dark"
    i = text.find(marker)
    j = text.find(");", i)
    block = text[i:j]
    out: dict[str, str] = {}
    for m in re.finditer(r"(\w+):\s*Color\((0x[0-9A-Fa-f]+)\)", block):
        out[m.group(1)] = m.group(2).upper().replace("0X", "0x")
    return out


def check(payload: dict, require_css: bool) -> int:
    errors = 0
    for kind in ("light", "dark"):
        dart = dart_hexes(kind)
        for slot, spec in payload["roles"].items():
            var = spec["css"]
            field = DART_FIELDS.get(var)
            if not field:
                continue
            want = spec[kind]
            got = dart.get(field)
            if want and got and got.upper() != want.upper():
                print(f"FAIL {kind} {slot} {field}: dart {got} ≠ css {want}", file=sys.stderr)
                errors += 1
            if require_css and not want:
                print(f"FAIL {kind} {slot}: CSS {var} not parsed", file=sys.stderr)
                errors += 1
            if not got:
                print(f"FAIL {kind} {field} missing in tactile_tokens.dart", file=sys.stderr)
                errors += 1
    return errors


def main() -> int:
    p = argparse.ArgumentParser()
    g = p.add_mutually_exclusive_group(required=True)
    g.add_argument("--write", action="store_true")
    g.add_argument("--check", action="store_true")
    p.add_argument("--tokens")
    args = p.parse_args()
    tokens = find_tokens(args.tokens)
    if args.write:
        if tokens is None:
            print("tokens.css not found", file=sys.stderr)
            return 2
        payload = extract(tokens)
        OUT.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
        print(f"wrote {OUT} from {tokens}")
        return 0 if check(payload, True) == 0 else 1
    if tokens is not None:
        payload = extract(tokens)
        if OUT.exists() and json.loads(OUT.read_text(encoding="utf-8")) != payload:
            print("tactile_theme_roles.json drift — rerun --write", file=sys.stderr)
            return 1
    elif OUT.exists():
        payload = json.loads(OUT.read_text(encoding="utf-8"))
    else:
        print("no roles json and no tokens.css", file=sys.stderr)
        return 2
    n = check(payload, tokens is not None)
    print("tactile theme roles OK" if n == 0 else f"{n} mismatches")
    return 0 if n == 0 else 1


if __name__ == "__main__":
    raise SystemExit(main())
