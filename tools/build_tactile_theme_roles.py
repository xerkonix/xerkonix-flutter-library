#!/usr/bin/env python3
"""Generate / check Material-slot → TACTILE CSS-var mapping.

Owner: xerkonix-flutter-library
Source: DS tactile/tokens.css + tactile/app-surface.css (product screen 6-B).
Do not hand-edit product _tokens.dart.

App-surface roles (DS flutter/APP_SURFACE_MAPPING.md) are resolved here:
`var()` and `color-mix(in srgb, …)` are computed with the CSS Color 5
premultiplied rule and rounded to 8-bit, so the Dart constants in
tactile_tokens.dart are checked against one computed value per theme.

  python3 tools/build_tactile_theme_roles.py --write [--tokens PATH]
  python3 tools/build_tactile_theme_roles.py --check [--tokens PATH]

`--tokens` points at tactile/tokens.css; app-surface.css is read from the
same folder. From a git worktree outside the workspace, pass --tokens.
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
DART_APP = LIB_ROOT / "xerkonix-design-system/lib/src/tactile/tactile_app_surface.dart"

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
    "tabBarTheme.indicator.fill": "--selected-fill",
    "tabBarTheme.indicator.border": "--selected-border",
    "navigationBarTheme.indicatorColor": "--selected-fill",
    "navigationRailTheme.indicatorColor": "--selected-fill",
    "navigation.indicatorBorder": "--selected-border",
    "navigation.selectedLabel": "--selected-text",
    "progressIndicatorTheme.color": "--accent",
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
    "--selected-fill": "selectedFill",
    "--selected-border": "selectedBorder",
    "--selected-text": "ink",
}

APP_SOURCE = "tactile/app-surface.css"

# DS flutter/APP_SURFACE_MAPPING.md role → (app-surface.css selector, property).
# Role names come from that table. Do not add names that are not there.
APP_ROLES: dict[str, tuple[str, str]] = {
    "appIntroSurface": (".app-surface .app-intro", "background"),
    "onAppIntro": (".app-surface .app-intro", "color"),
    "appIntroBody": (".app-surface .app-intro .app-intro-copy", "color"),
    "appIntroPrimaryFill": (".app-surface .app-intro .btn-primary", "background"),
    "appIntroPrimaryText": (".app-surface .app-intro .btn-primary", "color"),
    "appIntroPrimaryHover": (
        ".app-surface .app-intro .btn-primary:hover:not(:disabled)",
        "background",
    ),
    "appIntroFocusRing": (
        ".app-surface .app-intro .btn-primary:focus-visible",
        "outline",
    ),
    "onAppIntroAccent": (".app-surface .app-intro .app-intro-label", "color"),
    "appIntroLink": (".app-surface .app-intro .app-ink-link", "color"),
    "appIntroBrandWord": (
        ".app-surface .app-intro .app-brand-gradient",
        "background",
    ),
    "completionSheen": (".app-surface .app-completion::after", "background"),
    "currentLabel": (".app-surface .app-current", "color"),
    "keyMetric": (".app-surface .app-metric-value", "color"),
    "humanReviewLabel": (".app-surface .app-review-label", "color"),
    "selectedCue": (".app-surface .app-selected-cue", "color"),
    "humanReviewSurface": (".app-surface .app-review", "background"),
    "humanReviewBorder": (".app-surface .app-review", "border"),
}

# Values the mapping table names as a formula inside a role row, not as a
# role of its own. Checked by the Dart test, not stored as a token field.
APP_DERIVED: dict[str, tuple[str, str]] = {
    "appIntroSurface.border": (".app-surface .app-intro", "border"),
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


# ── app-surface.css resolver ───────────────────────────────────────────────
# RGBA with r/g/b on 0..255 and a on 0..1, kept as floats until the end.
Rgba = tuple[float, float, float, float]


def _strip_comments(css: str) -> str:
    return re.sub(r"/\*.*?\*/", " ", css, flags=re.S)


def _split_top(text: str, sep: str = ",") -> list[str]:
    """Split on `sep` outside parentheses. `sep=" "` splits on whitespace."""
    out: list[str] = []
    depth = 0
    cur = ""
    for ch in text:
        if ch == "(":
            depth += 1
        elif ch == ")":
            depth -= 1
        if depth == 0 and (ch == sep or (sep == " " and ch.isspace())):
            if cur.strip():
                out.append(cur.strip())
            cur = ""
            continue
        cur += ch
    if cur.strip():
        out.append(cur.strip())
    return out


def _rules(css: str) -> dict[str, dict[str, str]]:
    """Flat `selector → declarations` for top-level rules.

    @media / @keyframes / @supports bodies are skipped: they hold motion
    and fallbacks, not role values.
    """
    css = _strip_comments(css)
    out: dict[str, dict[str, str]] = {}
    i = 0
    n = len(css)
    while i < n:
        start = css.find("{", i)
        if start < 0:
            break
        selector = css[i:start].strip()
        depth = 1
        j = start + 1
        while j < n and depth:
            if css[j] == "{":
                depth += 1
            elif css[j] == "}":
                depth -= 1
            j += 1
        body = css[start + 1 : j - 1]
        i = j
        if selector.startswith("@"):
            continue
        decls = _decls(body)
        for m in re.finditer(r"(?<![\w-])([a-z-]+)\s*:\s*([^;]+)", body):
            if not m.group(1).startswith("--"):
                decls.setdefault(m.group(1), m.group(2).strip())
        for one in _split_top(selector):
            key = " ".join(one.split())
            out.setdefault(key, {}).update(decls)
    return out


def _rgba(raw: str, scope: dict[str, str], depth: int = 0) -> Rgba:
    raw = raw.strip()
    if depth > 20:
        raise SystemExit(f"var() loop at {raw}")
    if raw == "transparent":
        return (0.0, 0.0, 0.0, 0.0)
    m = re.fullmatch(r"var\(\s*(--[\w-]+)\s*\)", raw)
    if m:
        if m.group(1) not in scope:
            raise SystemExit(f"unresolved {m.group(1)}")
        return _rgba(scope[m.group(1)], scope, depth + 1)
    m = re.fullmatch(r"#([0-9a-fA-F]{6})", raw)
    if m:
        h = m.group(1)
        return (float(int(h[0:2], 16)), float(int(h[2:4], 16)), float(int(h[4:6], 16)), 1.0)
    m = re.fullmatch(
        r"rgba?\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*(?:,\s*([0-9.]+)\s*)?\)", raw
    )
    if m:
        a = float(m.group(4)) if m.group(4) is not None else 1.0
        return (float(m.group(1)), float(m.group(2)), float(m.group(3)), a)
    m = re.fullmatch(r"color-mix\((.*)\)", raw, flags=re.S)
    if m:
        parts = _split_top(m.group(1))
        if len(parts) != 3 or " ".join(parts[0].split()) != "in srgb":
            raise SystemExit(f"only color-mix(in srgb, …) is supported: {raw}")

        def side(text: str) -> tuple[Rgba, float | None]:
            bits = _split_top(text, " ")
            pct = None
            if bits and bits[-1].endswith("%"):
                pct = float(bits[-1][:-1]) / 100
                bits = bits[:-1]
            return _rgba(" ".join(bits), scope, depth + 1), pct

        c1, p1 = side(parts[1])
        c2, p2 = side(parts[2])
        if p1 is None and p2 is None:
            p1 = p2 = 0.5
        elif p1 is None:
            p1 = 1 - p2
        elif p2 is None:
            p2 = 1 - p1
        total = p1 + p2
        if abs(total - 1) > 1e-9:
            raise SystemExit(f"color-mix percentages must sum to 100%: {raw}")
        # CSS Color 5: interpolate premultiplied, then un-premultiply.
        a = c1[3] * p1 + c2[3] * p2
        if a == 0:
            return (0.0, 0.0, 0.0, 0.0)
        rgb = [(c1[k] * c1[3] * p1 + c2[k] * c2[3] * p2) / a for k in range(3)]
        return (rgb[0], rgb[1], rgb[2], a)
    raise SystemExit(f"cannot resolve colour {raw!r}")


def _hex(c: Rgba) -> str:
    def q(x: float) -> int:
        return max(0, min(255, int(x + 0.5)))

    return "0x" + "".join(f"{v:02X}" for v in (q(c[3] * 255), q(c[0]), q(c[1]), q(c[2])))


def _prop_colors(value: str, scope: dict[str, str]) -> list[str]:
    """Colours in a background / border / outline / color value."""
    value = value.strip()
    g = re.fullmatch(r"linear-gradient\((.*)\)", value, flags=re.S)
    if g:
        stops = _split_top(g.group(1))
        if stops and re.fullmatch(r"-?[0-9.]+deg", stops[0]):
            stops = stops[1:]
        out = []
        for stop in stops:
            bits = _split_top(stop, " ")
            if bits and bits[-1].endswith("%"):
                bits = bits[:-1]
            out.append(_hex(_rgba(" ".join(bits), scope)))
        return out
    bits = _split_top(value, " ")
    if len(bits) > 1:
        # `1px solid <colour>` / `3px solid <colour>` — colour is last.
        return [_hex(_rgba(bits[-1], scope))]
    return [_hex(_rgba(value, scope))]


def _app_value(role: str, colors: list[str]) -> str | list[str]:
    if role == "appIntroBrandWord":
        return colors
    if role == "completionSheen":
        # Sweep is transparent → tint → transparent; the role is the tint.
        tints = [c for c in colors if not c.startswith("0x00")]
        if len(tints) != 1:
            raise SystemExit(f"completionSheen expects one tint stop: {colors}")
        return tints[0]
    if len(colors) != 1:
        raise SystemExit(f"{role} expects one colour: {colors}")
    return colors[0]


def _duration_ms(raw: str) -> int:
    m = re.fullmatch(r"([0-9.]+)(ms|s)", raw.strip())
    if not m:
        raise SystemExit(f"bad duration {raw}")
    v = float(m.group(1))
    return int(round(v * 1000 if m.group(2) == "s" else v))


def _cubic(raw: str) -> list[float]:
    m = re.fullmatch(r"cubic-bezier\(([^)]*)\)", raw.strip())
    if not m:
        raise SystemExit(f"bad easing {raw}")
    return [float(x) for x in m.group(1).split(",")]


def extract_app(app_css: str, light_tokens: dict[str, str], dark_tokens: dict[str, str]) -> dict:
    rules = _rules(app_css)
    base = rules.get(".app-surface")
    dark_over = rules.get('[data-theme="dark"] .app-surface')
    if base is None or dark_over is None:
        raise SystemExit("app-surface.css: .app-surface / dark blocks missing")
    scopes = {
        "light": {**light_tokens, **base},
        "dark": {**dark_tokens, **base, **dark_over},
    }

    def resolve(table: dict[str, tuple[str, str]]) -> dict:
        out = {}
        for role, (selector, prop) in table.items():
            decls = rules.get(selector)
            if decls is None or prop not in decls:
                raise SystemExit(f"app-surface.css: {selector} {{ {prop} }} missing")
            entry: dict = {"css": f"{selector} {{ {prop} }}", "expr": decls[prop]}
            for kind, scope in scopes.items():
                entry[kind] = _app_value(role, _prop_colors(decls[prop], scope))
            out[role] = entry
        return out

    sheen = next(
        (b for sel, b in rules.items() if sel == ".app-surface .app-completion::after"),
        None,
    )
    anim = (sheen or {}).get("animation", "")
    sheen_ms = re.search(r"([0-9.]+m?s)", anim)
    if not sheen_ms or " 1 " not in f" {anim} ":
        raise SystemExit("app-surface.css: .app-completion::after must run once")
    return {
        "source": APP_SOURCE,
        "roles": resolve(APP_ROLES),
        "derived": resolve(APP_DERIVED),
        "motion": {
            "routeFade": {
                "css": "--app-view-duration / --app-view-ease",
                "durationMs": _duration_ms(base["--app-view-duration"]),
                "cubic": _cubic(base["--app-view-ease"]),
                "reducedMotionMs": 0,
            },
            "completionSheen": {
                "css": ".app-completion::after animation",
                "durationMs": _duration_ms(sheen_ms.group(1)),
                "curve": "ease-in-out" if "ease-in-out" in anim else anim,
                "iterations": 1,
                "reducedMotion": "none",
            },
        },
    }


def find_app_css(tokens: Path) -> Path | None:
    path = tokens.parent / "app-surface.css"
    return path if path.is_file() else None


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
    payload = {
        "kind": "xerkonix-tactile-theme-roles",
        "owner": "xerkonix-flutter-library",
        "source": "tactile/tokens.css",
        "generator": "tools/build_tactile_theme_roles.py",
        "not": "product _tokens.dart / tokens.css v4 ledger",
        "roles": roles,
    }
    app_css = find_app_css(css_path)
    if app_css is None:
        raise SystemExit(f"{APP_SOURCE} not found next to {css_path}")
    payload["app"] = extract_app(app_css.read_text(encoding="utf-8"), light, dark)
    return payload


def _dart_block(kind: str) -> str:
    text = DART.read_text(encoding="utf-8")
    marker = "static const XkTactileTokens light" if kind == "light" else "static const XkTactileTokens dark"
    i = text.find(marker)
    j = text.find("\n  );", i)
    return text[i:j]


def _norm(h: str) -> str:
    return h.upper().replace("0X", "0x")


def dart_hexes(kind: str) -> dict[str, str]:
    out: dict[str, str] = {}
    for m in re.finditer(r"(\w+):\s*Color\((0x[0-9A-Fa-f]+)\)", _dart_block(kind)):
        out[m.group(1)] = _norm(m.group(2))
    return out


def dart_color_lists(kind: str) -> dict[str, list[str]]:
    out: dict[str, list[str]] = {}
    pattern = r"(\w+):\s*<Color>\[([^\]]*)\]"
    for m in re.finditer(pattern, _dart_block(kind)):
        out[m.group(1)] = [_norm(h) for h in re.findall(r"Color\((0x[0-9A-Fa-f]+)\)", m.group(2))]
    return out


def dart_motion() -> dict[str, str]:
    """`static const` motion values in tactile_app_surface.dart."""
    text = DART_APP.read_text(encoding="utf-8") if DART_APP.is_file() else ""
    out: dict[str, str] = {}
    for m in re.finditer(r"static const (?:Duration|Cubic) (\w+) =\s*(?:Duration|Cubic)\(([^)]*)\)", text):
        out[m.group(1)] = " ".join(m.group(2).split())
    return out


def check_app(payload: dict) -> int:
    app = payload.get("app")
    if not app:
        print("FAIL roles json has no app section — rerun --write", file=sys.stderr)
        return 1
    errors = 0
    for kind in ("light", "dark"):
        hexes = dart_hexes(kind)
        lists = dart_color_lists(kind)
        for role, spec in app["roles"].items():
            want = spec[kind]
            got = lists.get(role) if isinstance(want, list) else hexes.get(role)
            if got is None:
                print(f"FAIL {kind} app role {role} missing in tactile_tokens.dart", file=sys.stderr)
                errors += 1
            elif (got != [_norm(w) for w in want]) if isinstance(want, list) else got != _norm(want):
                print(f"FAIL {kind} app role {role}: dart {got} ≠ css {want}", file=sys.stderr)
                errors += 1
    motion = dart_motion()
    fade = app["motion"]["routeFade"]
    want_d = f"milliseconds: {fade['durationMs']}"
    want_c = ", ".join(_dart_num(x) for x in fade["cubic"])
    sheen = f"milliseconds: {app['motion']['completionSheen']['durationMs']}"
    for name, want in (("routeFadeDuration", want_d), ("routeFadeCurve", want_c), ("completionSheenDuration", sheen)):
        if motion.get(name) != want:
            print(f"FAIL motion {name}: dart {motion.get(name)!r} ≠ css {want!r}", file=sys.stderr)
            errors += 1
    return errors


def _dart_num(x: float) -> str:
    return str(int(x)) if float(x).is_integer() else repr(float(x))


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
    return errors + check_app(payload)


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
