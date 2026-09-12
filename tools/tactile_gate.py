#!/usr/bin/env python3
# ruff: noqa: E501
"""TACTILE 파리티 게이트 — 정적 HTML/CSS 표면이 디자인 정본에서 이탈하지 않게 막는다.

정본 스크립트는 xerkonix-tactile-design/tools/tactile_gate.py, 리포별 설정은
tactile_gate.json. 소비 리포에는 이 파일을 그대로 복사하고, 달라지는 것(검사
대상 glob·미러 목록·예외 목록)은 옆의 tactile_gate.json 에만 적는다.

  python3 tools/tactile_gate.py             # 검사 (CI)
  python3 tools/tactile_gate.py --verbose
  python3 tools/tactile_gate.py --selftest

검사는 TACTILE.md §8 를 정적 범위에서 집행한다. 썸네일·워드마크 가리기·axe 는
이 스크립트가 돌리지 않는다(단계 보고에서 해당 없음으로 적는다).

v4.0.1 어휘: 캔버스/잉크/아쿠아마린/글래스. v3 의 --x-* 토큰은 선언도 사용도 실패다.
라이트 --glass/.32 · --glass-strong/.52 (v4.0.0 의 .55/.78 은 흰 판).
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import sys

EXPECT_VERSION = "v4.0.1"

# ─────────────────────────────────────────────────────────────────────────────
# v4.0.0 기대 테이블 (tokens.css 정본)
# ─────────────────────────────────────────────────────────────────────────────
LIGHT: dict[str, str] = {
    # 캔버스와 광원
    "--canvas": "#F5F5F5", "--ground-hi": "#FFFFFF",
    # 잉크 — --ink-3 는 비활성·플레이스홀더·장식 전용(캔버스 대비 2.31:1)
    "--ink": "#0C1114", "--ink-2": "#5E6A6E", "--ink-3": "#9AA5A8",
    "--rule": "rgba(12,17,20,.10)",
    # 아쿠아마린 — 텍스트에는 deep 이상만
    "--aqua-100": "#E3F3F7", "--aqua-tint": "#C0E3EC", "--aqua-hi": "#92CCDC",
    "--aqua": "#6EB4C4", "--aqua-mid": "#59A1B0", "--aqua-shade": "#33778D",
    "--aqua-deep": "#2E6774", "--aqua-ink": "#1B4650",
    # 글래스 재질
    "--glass": "rgba(255,255,255,.32)", "--glass-strong": "rgba(255,255,255,.52)",
    "--glass-edge": "rgba(255,255,255,.90)", "--glass-edge-2": "rgba(255,255,255,.40)",
    "--glass-shadow": "0 24px 60px -36px rgba(12,17,20,.30),0 1px 3px -1px rgba(12,17,20,.08)",
    "--spec": "rgba(255,255,255,.95)", "--inset-bg": "rgba(12,17,20,.035)",
    "--head-glass": "rgba(245,245,245,.84)",
    # 라운드
    "--r-panel": "16px", "--r-card": "14px", "--r-inset": "12px", "--r-ctl": "12px", "--r-tag": "6px",
    # 모션
    "--ease-out": "cubic-bezier(.2,.8,.2,1)", "--ease-sweep": "cubic-bezier(.4,0,.5,1)",
    "--t-state": ".9s", "--t-hover": ".25s",
    # 확장: 시맨틱 잉크 · 관계 온도
    "--ok": "#4F7868", "--warn": "#A95C11", "--bad": "#C13030",
    "--warm": "#B8503A", "--cool": "#3E6B8F",
    # 확장: 간격 · 글자 크기 · 폭 (v3.1.0 스케일 유지)
    "--sp-1": "4px", "--sp-2": "8px", "--sp-3": "12px", "--sp-4": "16px",
    "--sp-5": "24px", "--sp-6": "32px", "--sp-7": "48px",
    "--fs-display": "58px", "--fs-display-mobile": "34px",
    "--fs-section": "44px", "--fs-section-mobile": "30px",
    "--fs-page": "32px", "--fs-page-mobile": "28px",
    "--fs-title": "22px", "--fs-title-mobile": "20px",
    "--fs-body": "17px", "--fs-body-mobile": "16px",
    "--fs-small": "15px", "--fs-caption": "13px", "--fs-label": "11px",
    "--leading-body": "1.6", "--leading-heading": "1.2",
    "--content-width": "1160px", "--reading-width": "760px",
    "--section-space": "72px", "--section-space-mobile": "40px",
    "--gutter": "24px", "--gutter-mobile": "20px", "--control-height": "48px",
}

DARK_OVERRIDE: dict[str, str] = {
    "--canvas": "#0B0F11", "--ground-hi": "#1A2023",
    "--ink": "#F2F5F5", "--ink-2": "#98A4A7", "--ink-3": "#5E6A6E",
    "--rule": "rgba(242,245,245,.10)",
    "--aqua-100": "#12333C", "--aqua-tint": "#1F4C58", "--aqua-hi": "#A6D8E5",
    "--aqua": "#6EB4C4", "--aqua-mid": "#4F97A8", "--aqua-shade": "#2E6774",
    "--aqua-deep": "#92CCDC", "--aqua-ink": "#10303A",
    "--glass": "rgba(255,255,255,.06)", "--glass-strong": "rgba(255,255,255,.10)",
    "--glass-edge": "rgba(255,255,255,.22)", "--glass-edge-2": "rgba(255,255,255,.07)",
    "--glass-shadow": "0 24px 60px -36px rgba(0,0,0,.8),0 1px 3px -1px rgba(0,0,0,.5)",
    "--spec": "rgba(255,255,255,.45)", "--inset-bg": "rgba(255,255,255,.05)",
    "--head-glass": "rgba(11,15,17,.78)",
    "--ok": "#7FB59E", "--warn": "#EC9A50", "--bad": "#E67274",
    "--warm": "#DE9074", "--cool": "#8AA8C2",
}
DARK: dict[str, str] = {**LIGHT, **DARK_OVERRIDE}

# 값 테이블 밖이지만 계약에 있는 이름(파리티 비교 대상 아님)
CONTRACT_ONLY_VARS = {"--font"}

ANCHORS_REQUIRED = ("--canvas", "--ink")

# ─────────────────────────────────────────────────────────────────────────────
# 어휘
# ─────────────────────────────────────────────────────────────────────────────
# 텍스트에 금지된 아쿠아(글자는 --aqua-deep · --aqua-ink 만)
AQUA_TEXT_VARS = ("--aqua", "--aqua-hi", "--aqua-mid", "--aqua-100", "--aqua-tint", "--aqua-shade")
# hex 로 직접 쓴 경우. --aqua-deep 과 겹치는 #92CCDC·#2E6774 는 뜻이 갈려 빼둔다(raw-color 가 잡는다)
AQUA_TEXT_HEX = ("#6EB4C4", "#59A1B0", "#4F97A8", "#E3F3F7", "#C0E3EC", "#33778D",
                 "#12333C", "#1F4C58", "#A6D8E5")
# 면을 아쿠아로 칠해도 되는 자리
AQUA_FILL_ALLOW = (
    "gem", "x-btn", "x-tgl", "x-scan", "x-loader", "bar", "selected", "flag",
    "indicator", "gauge", "fill", '[aria-pressed="true"]', ".on", ".active", ".cur", "aria-current",
)
# --ink-3 는 비활성·플레이스홀더·장식 전용
INK3_ALLOW = (":disabled", "::placeholder", "[aria-disabled", "placeholder", "disabled")
# 13px 바닥의 예외 — 라벨·태그 계열은 11px 까지
LABEL_HINTS = ("tag", "label", "eyebrow", "anchor", "badge", "bdg", "group",
               "techpart", "part-label", "x-eyebrow")
# 무한 반복이 허용된 keyframes
INFINITE_OK = ("tactile-sweep", "tactile-loader")
# raw-color 를 면제받는 파일(팔레트와 재질 원본)
RAW_COLOR_EXEMPT_FILES = ("tokens.css", "light.css", "tactile.css")

TEXT_FLOOR_PX = 13.0
LABEL_FLOOR_PX = 11.0
PILL_PX = 100.0        # border-radius 100px 이상은 알약
PILL_EM = 4.0
PILL_VIEWPORT = 40.0

# ─────────────────────────────────────────────────────────────────────────────
# 정규식
# ─────────────────────────────────────────────────────────────────────────────
RE_LEGACY_DECL = re.compile(
    r"(?<![\w-])(--(?:x-[\w-]+|point|neu-raise|neu-inset|gray-000|serif|bg|surface|action|gem|hue-[1-8]|hl-light|tint[\w-]*))\s*:",
    re.I,
)
RE_LEGACY_WORD = re.compile(r"\bWeave\b", re.I)
RE_LEGACY_ONE_LINE = re.compile(r"$never^")
RE_FONT_LINK = re.compile(
    r"maru-buri|hangeul\.(?:pstatic|naver)\.net|IBM\+Plex|IBM Plex|JetBrains(\+| )Mono",
    re.I,
)
RE_STAR_NONE = re.compile(r"\*\s*\{[^}]*(?:transition|animation)\s*:\s*none", re.I | re.S)
RE_LINK_TOKENS = re.compile(r"""<link[^>]+href\s*=\s*["'][^"']*\btokens\.css""", re.I)
RE_LINK_LIGHT = re.compile(r"""<link[^>]+href\s*=\s*["'][^"']*\blight\.css""", re.I)
RE_INLINE_TOKEN_ROOT = re.compile(r":root\s*\{[^}]*--canvas\s*:", re.I)
RE_DECL = re.compile(r"(--[\w-]+)\s*:\s*([^;{}]*?)\s*(?=[;}])")
RE_DARK_SEL = re.compile(r"\[data-theme\s*=\s*[\"']?dark|prefers-color-scheme\s*:\s*dark", re.I)
RE_VAR = re.compile(r"var\(\s*(--[\w-]+)\s*(?:,[^()]*)?\)")
RE_HEX = re.compile(r"#[0-9a-f]{3,8}", re.I)
RE_NUM = re.compile(r"(?<![\w#])(\d*\.?\d+)")
RE_NEU_RAISE = re.compile(r"--neu-raise|neu-raise", re.I)
RE_RAW_HEX = re.compile(r"#[0-9a-f]{3,8}(?![\w-])", re.I)
RE_RAW_FUNC = re.compile(r"(?<![\w-])(rgba?|hsla?)\s*\(", re.I)
RE_PX = re.compile(r"(?<![\w.])(\d*\.?\d+)px", re.I)
RE_LEN = re.compile(r"(?<![\w.#])(\d*\.?\d+(?:e[+-]?\d+)?)(px|pt|rem|em|ch|vh|vw|vmin|vmax)", re.I)
RE_W3 = re.compile(r"(?<![\w.#-])(\d{3,4})(?![\w.%])")
RE_BOLD_WORD = re.compile(r"\b(bold|bolder)\b", re.I)
RE_FULL_ROTATE = re.compile(r"rotate[xyz]?\(\s*-?(?:360deg|1turn)\s*\)", re.I)
RE_KEYFRAMES = re.compile(r"@(?:-\w+-)?keyframes\s+([\w-]+)\s*\{", re.I)
RE_DARK_MEDIA_OPEN = re.compile(r"@media[^{]*prefers-color-scheme\s*:\s*dark[^{]*\{", re.I)
RE_DARK_ATTR_OPEN = re.compile(r":root\s*\[\s*data-theme\s*=\s*[\"']?dark[\"']?\s*\]\s*\{", re.I)
RE_SCALE_ROTATE = re.compile(r"\b(scale[xyz3d]*|rotate[xyz3d]*)\s*\(", re.I)


class Finding:
    __slots__ = ("path", "line", "kind", "detail")

    def __init__(self, path: str, line: int, kind: str, detail: str) -> None:
        self.path, self.line, self.kind, self.detail = path, line, kind, detail

    def __str__(self) -> str:
        return f"{self.path}:{self.line}: [{self.kind}] {self.detail}"


# ─────────────────────────────────────────────────────────────────────────────
# 텍스트 다루기
# ─────────────────────────────────────────────────────────────────────────────
def _blank(text: str, start: int, end: int) -> str:
    seg = "".join(c if c == "\n" else " " for c in text[start:end])
    return text[:start] + seg + text[end:]


def strip_comments(text: str) -> str:
    for pat in (re.compile(r"/\*.*?\*/", re.S), re.compile(r"<!--.*?-->", re.S)):
        while True:
            m = pat.search(text)
            if not m:
                break
            text = _blank(text, m.start(), m.end())
    return text


def css_regions(text: str, is_html: bool) -> str:
    if not is_html:
        return text
    keep = [False] * len(text)
    for m in re.finditer(r"<style\b[^>]*>(.*?)</style\s*>", text, re.S | re.I):
        for i in range(m.start(1), m.end(1)):
            keep[i] = True
    return "".join(c if (keep[i] or c == "\n") else " " for i, c in enumerate(text))


def css_of(raw: str, is_html: bool) -> str:
    return css_regions(strip_comments(raw), is_html)


def line_of(text: str, idx: int) -> int:
    return text.count("\n", 0, idx) + 1


def _norm_num(m: re.Match[str]) -> str:
    f = float(m.group(1))
    s = f"{f:.6f}".rstrip("0").rstrip(".")
    if s.startswith("0.") and len(s) > 2:
        s = s[1:]
    return s or "0"


def normalize(value: str) -> str:
    v = value.strip().rstrip(";").lower()
    v = re.sub(r"\s+", " ", v)

    def hexfix(m: re.Match[str]) -> str:
        h = m.group(0)
        if len(h) == 4:
            h = "#" + "".join(c * 2 for c in h[1:])
        return h

    v = RE_HEX.sub(hexfix, v)
    holes: list[str] = []

    def stash(m: re.Match[str]) -> str:
        holes.append(m.group(0))
        return f"\x00{len(holes) - 1}\x00"

    v = RE_HEX.sub(stash, v)
    v = RE_NUM.sub(_norm_num, v)
    v = re.sub(r"\x00(\d+)\x00", lambda m: holes[int(m.group(1))], v)
    v = re.sub(r"(?<![\w.])0px\b", "0", v)
    return re.sub(r"\s*", "", v)


def resolve(value: str, table: dict[str, str], depth: int = 0) -> str:
    if depth > 12:
        return value

    def sub(m: re.Match[str]) -> str:
        name = m.group(1)
        if name in table:
            return resolve(table[name], table, depth + 1)
        return m.group(0)

    out = RE_VAR.sub(sub, value)
    return out if out == value else resolve(out, table, depth + 1)


def prelude_stack(css: str) -> list[tuple[int, int, bool]]:
    """(본문 시작, 본문 끝, 다크인가). 바깥 @media 프렐류드가 안쪽 블록을 덮는다."""
    spans: list[tuple[int, int, bool]] = []
    stack: list[tuple[int, int]] = []
    last_close = 0
    for m in re.finditer(r"[{}]", css):
        if m.group(0) == "{":
            pre_start = max(last_close, stack[-1][0] if stack else 0)
            stack.append((m.end(), pre_start))
        else:
            if stack:
                body_start, pre_start = stack.pop()
                prelude = css[pre_start:body_start - 1]
                prelude = prelude[prelude.rfind("}") + 1:]
                spans.append((body_start, m.start(), bool(RE_DARK_SEL.search(prelude))))
            last_close = m.end()
    return spans


def collect_declarations(css: str) -> list[tuple[str, str, int, bool]]:
    spans = prelude_stack(css)
    out: list[tuple[str, str, int, bool]] = []
    for m in RE_DECL.finditer(css):
        i = m.start()
        dark = any(s <= i < e and d for s, e, d in spans)
        out.append((m.group(1), m.group(2), line_of(css, i), dark))
    return out


def _decl_of(css: str, a: int, b: int) -> tuple[str, str, int] | None:
    chunk = css[a:b]
    colon = chunk.find(":")
    if colon < 0:
        return None
    prop = chunk[:colon].strip()
    if not prop or not re.fullmatch(r"[-\w]+", prop):
        return None
    idx = a + (len(chunk) - len(chunk.lstrip()))
    return prop.lower(), chunk[colon + 1:], idx


def iter_declarations(css: str):
    """rule 본문 안의 `prop: value` 만 흘린다 — 셀렉터·@규칙 프렐류드는 건너뛴다."""
    depth = 0
    start = 0
    for i, ch in enumerate(css):
        if ch == "{":
            depth += 1
            start = i + 1
        elif ch == "}":
            if depth > 0:
                d = _decl_of(css, start, i)
                if d:
                    yield d
            depth = max(0, depth - 1)
            start = i + 1
        elif ch == ";":
            if depth > 0:
                d = _decl_of(css, start, i)
                if d:
                    yield d
            start = i + 1


def enclosing_selector(css: str, idx: int) -> str:
    open_at = css.rfind("{", 0, idx)
    if open_at < 0:
        return "?"
    start = max(css.rfind("}", 0, open_at), css.rfind("{", 0, open_at)) + 1
    return " ".join(css[start:open_at].split())


def short(sel: str) -> str:
    return sel if len(sel) <= 90 else sel[:87] + "…"


def block_body(css: str, open_brace: int) -> tuple[str, int]:
    depth = 0
    for i in range(open_brace, len(css)):
        if css[i] == "{":
            depth += 1
        elif css[i] == "}":
            depth -= 1
            if depth == 0:
                return css[open_brace + 1:i], i
    return css[open_brace + 1:], len(css)


def keyframes_spans(css: str) -> list[tuple[int, int, str]]:
    out: list[tuple[int, int, str]] = []
    for m in RE_KEYFRAMES.finditer(css):
        body, end = block_body(css, m.end() - 1)
        out.append((m.end(), end, m.group(1)))
    return out


def split_layers(value: str) -> list[str]:
    layers, buf, depth = [], [], 0
    for ch in value:
        if ch == "(":
            depth += 1
            buf.append(ch)
        elif ch == ")":
            depth = max(0, depth - 1)
            buf.append(ch)
        elif ch == "," and depth == 0:
            layers.append("".join(buf).strip())
            buf = []
        else:
            buf.append(ch)
    if buf:
        layers.append("".join(buf).strip())
    return [L for L in layers if L]


def shadow_offsets(layer: str) -> tuple[str, str] | None:
    """첫 두 길이 값 (inset 다음). 길이가 없으면 None."""
    tokens: list[str] = []
    buf, depth = [], 0
    for ch in layer.strip():
        if ch == "(":
            depth += 1
            buf.append(ch)
        elif ch == ")":
            depth = max(0, depth - 1)
            buf.append(ch)
        elif ch.isspace() and depth == 0:
            if buf:
                tokens.append("".join(buf))
                buf = []
        else:
            buf.append(ch)
    if buf:
        tokens.append("".join(buf))
    if tokens and tokens[0].lower() == "inset":
        tokens = tokens[1:]
    lengths = []
    for t in tokens:
        if t.lower() in {"none", "inherit", "unset", "initial"}:
            return None
        if any(c.isdigit() for c in t) or t.startswith(("var(", "calc(")):
            lengths.append(t)
            if len(lengths) == 2:
                return lengths[0], lengths[1]
        else:
            break
    return None


def is_inset_layer(layer: str) -> bool:
    return bool(re.match(r"^\s*inset\b", layer, re.I)) or bool(re.search(r"\binset\b", layer, re.I))


def is_negative_offset(tok: str) -> bool:
    t = tok.strip()
    if t.startswith("calc("):
        if re.search(r"\*\s*-\s*\d", t) or re.search(r"-\s*\d+(?:px|em|rem|%)", t):
            return True
        return False
    return bool(re.match(r"-\d", t)) or t.startswith("-.")


def is_zero_offset(tok: str) -> bool:
    return normalize(tok) in {"0", "0px"}


def first_px(value: str) -> float | None:
    m = RE_PX.search(value)
    return float(m.group(1)) if m else None


# ─────────────────────────────────────────────────────────────────────────────
# 검사
# ─────────────────────────────────────────────────────────────────────────────
def scan_light_source(path: str, raw: str, is_html: bool, allow: list[str] | None = None) -> list[Finding]:
    css = css_of(raw, is_html)
    out: list[Finding] = []
    allow = allow or []
    for prop, value, idx in iter_declarations(css):
        if prop != "box-shadow":
            continue
        sel = enclosing_selector(css, idx)
        if any(a in sel for a in allow):
            continue
        if RE_NEU_RAISE.search(value):
            out.append(Finding(path, line_of(css, idx), "light-source",
                               "v2 --neu-raise 패턴 — 음수 하이라이트 그림자는 실패"))
            continue
        for layer in split_layers(value):
            offs = shadow_offsets(layer)
            if not offs:
                continue
            x, y = offs
            if is_zero_offset(x) and is_zero_offset(y):
                continue
            if is_negative_offset(x) or is_negative_offset(y):
                out.append(Finding(
                    path, line_of(css, idx), "light-source",
                    f"box-shadow 음수 오프셋 ({x}, {y}) — {short(sel)}. "
                    "빛은 좌상단 하나. 허용: inset 1px 1px 하이라이트, inset 0 0 0 Npx 링, 양수 오프셋"))
    return out


def scan_neumorphic(path: str, raw: str, is_html: bool) -> list[Finding]:
    css = css_of(raw, is_html)
    out: list[Finding] = []
    for prop, value, idx in iter_declarations(css):
        if prop != "box-shadow":
            continue
        if "--glass-shadow" in value:
            continue
        layers = split_layers(value)
        drop = [L for L in layers if not is_inset_layer(L) and shadow_offsets(L)]
        if len(drop) >= 3:
            out.append(Finding(
                path, line_of(css, idx), "neumorphic",
                f"box-shadow 드롭 레이어 {len(drop)}겹 — {short(enclosing_selector(css, idx))}. "
                "그림자 여러 겹은 뉴모픽이다. 글래스는 var(--glass-shadow) 한 장 + inset 하이라이트"))
    return out


def scan_aqua(path: str, raw: str, is_html: bool, fill_allow: list[str] | None = None) -> list[Finding]:
    css = css_of(raw, is_html)
    out: list[Finding] = []
    allow = list(AQUA_FILL_ALLOW) + list(fill_allow or [])
    for prop, value, idx in iter_declarations(css):
        low = value.lower()
        if prop == "color":
            hit = next((v for v in AQUA_TEXT_VARS if re.search(r"var\(\s*" + re.escape(v) + r"\s*\)", low)), None)
            if not hit:
                hit = next((h for h in AQUA_TEXT_HEX if h.lower() in low), None)
            if hit:
                out.append(Finding(
                    path, line_of(css, idx), "aqua-text",
                    f"color:{hit} — {short(enclosing_selector(css, idx))}. "
                    "글자 아쿠아는 --aqua-deep(라이트 5.82:1) 과 원석 위 --aqua-ink 만"))
        if prop in ("background", "background-color", "background-image"):
            hit = next((v for v in ("--aqua", "--aqua-hi", "--aqua-mid", "--aqua-100",
                                    "--aqua-tint", "--aqua-shade", "--aqua-deep")
                        if re.search(r"var\(\s*" + re.escape(v) + r"\s*\)", low)), None)
            if not hit:
                hit = next((h for h in AQUA_TEXT_HEX if h.lower() in low), None)
            if not hit:
                continue
            sel = enclosing_selector(css, idx)
            if any(a in sel for a in allow):
                continue
            out.append(Finding(
                path, line_of(css, idx), "aqua-fill",
                f"아쿠아 면 칠 {hit} — {short(sel)}. "
                "면은 원석(.gem/.x-btn)·선택 하나·인디케이터·게이지·스캔선에만"))
    return out


def scan_ink3(path: str, raw: str, is_html: bool, allow: list[str] | None = None) -> list[Finding]:
    css = css_of(raw, is_html)
    out: list[Finding] = []
    hints = list(INK3_ALLOW) + list(allow or [])
    for prop, value, idx in iter_declarations(css):
        if prop not in ("color", "fill"):
            continue
        if not re.search(r"var\(\s*--ink-3\s*\)", value, re.I):
            continue
        sel = enclosing_selector(css, idx)
        if any(a in sel for a in hints):
            continue
        out.append(Finding(
            path, line_of(css, idx), "ink3-text",
            f"{prop}:var(--ink-3) — {short(sel)}. "
            "--ink-3 는 캔버스 대비 2.31:1 이라 비활성·플레이스홀더·장식 전용. 읽는 글자는 --ink-2 까지"))
    return out


def _is_shadow_value(prop: str, value: str) -> bool:
    return prop.endswith("shadow") or "drop-shadow(" in value.lower()


def scan_raw_color(path: str, raw: str, is_html: bool, allow: list[str] | None = None) -> list[Finding]:
    if os.path.basename(path).lower() in RAW_COLOR_EXEMPT_FILES:
        return []
    css = css_of(raw, is_html)
    out: list[Finding] = []
    allow = allow or []
    for prop, value, idx in iter_declarations(css):
        # 정본 토큰을 다시 선언하는 자리는 parity 가 본다(값이 같은지 아닌지가 논점이다)
        if prop.startswith("--") and prop in DARK:
            continue
        sel = enclosing_selector(css, idx)
        if any(a in sel for a in allow):
            continue
        for m in RE_RAW_HEX.finditer(value):
            if value[max(0, m.start() - 4):m.start()].lower().endswith("url("):
                continue
            out.append(Finding(
                path, line_of(css, idx), "raw-color",
                f"{prop}:{m.group(0)} — {short(sel)}. 색은 tokens.css 토큰에서만 온다"))
            break
        if not _is_shadow_value(prop, value):
            m = RE_RAW_FUNC.search(value)
            if m:
                out.append(Finding(
                    path, line_of(css, idx), "raw-color",
                    f"{prop}:{m.group(1)}(…) — {short(sel)}. 색은 tokens.css 토큰에서만 온다"
                    " (그림자 알파만 예외)"))
    return out


def scan_font(path: str, raw: str, is_html: bool) -> list[Finding]:
    """font-literal(Pretendard 외 서체) · weight-cap(700 이상)."""
    css = css_of(raw, is_html)
    out: list[Finding] = []
    for prop, value, idx in iter_declarations(css):
        low = value.strip().lower()
        if prop in ("font-family", "font"):
            sel = enclosing_selector(css, idx)
            if "@font-face" not in sel and low.rstrip(";").strip() not in {"inherit", "initial", "unset", "revert"}:
                if "var(--font)" not in low.replace(" ", "") and "pretendard" not in low:
                    out.append(Finding(
                        path, line_of(css, idx), "font-literal",
                        f"{prop}:{short(value.strip())} — {short(sel)}. "
                        "서체는 var(--font)(Pretendard) 하나. 세리프·모노 금지"))
        if prop == "font-weight":
            w = low.rstrip(";").strip()
            if RE_BOLD_WORD.fullmatch(w):
                out.append(Finding(path, line_of(css, idx), "weight-cap",
                                   f"font-weight:{w} — {short(enclosing_selector(css, idx))}. 굵기 상한은 600"))
            else:
                try:
                    if float(w) >= 700:
                        out.append(Finding(path, line_of(css, idx), "weight-cap",
                                           f"font-weight:{w} — {short(enclosing_selector(css, idx))}. 굵기 상한은 600"))
                except ValueError:
                    pass
        elif prop == "font":
            hits = [int(n) for n in RE_W3.findall(low)]
            heavy = [n for n in hits if 700 <= n <= 1000]
            if heavy or RE_BOLD_WORD.search(low):
                out.append(Finding(
                    path, line_of(css, idx), "weight-cap",
                    f"font 축약의 굵기 {heavy[0] if heavy else 'bold'} — {short(enclosing_selector(css, idx))}. 굵기 상한은 600"))
    return out


def scan_radius(path: str, raw: str, is_html: bool) -> list[Finding]:
    css = css_of(raw, is_html)
    out: list[Finding] = []
    for prop, value, idx in iter_declarations(css):
        if not (prop == "border-radius" or (prop.startswith("border-") and prop.endswith("-radius"))):
            continue
        v = resolve(value, LIGHT)
        for num, unit in RE_LEN.findall(v):
            try:
                n = float(num)
            except ValueError:
                continue
            u = unit.lower()
            bad = ((u in ("px", "pt") and n >= PILL_PX)
                   or (u in ("em", "rem", "ch") and n >= PILL_EM)
                   or (u in ("vh", "vw", "vmin", "vmax") and n >= PILL_VIEWPORT))
            if bad:
                out.append(Finding(
                    path, line_of(css, idx), "pill-radius",
                    f"{prop}:{short(value.strip())} ({num}{unit}) — {short(enclosing_selector(css, idx))}. "
                    "알약 금지. 라운드는 --r-panel/--r-card/--r-inset/--r-ctl/--r-tag, 원은 50%"))
                break
    return out


def scan_hover_scale(path: str, raw: str, is_html: bool) -> list[Finding]:
    css = css_of(raw, is_html)
    out: list[Finding] = []
    for prop, value, idx in iter_declarations(css):
        if prop != "transform":
            continue
        sel = enclosing_selector(css, idx)
        if ":hover" not in sel and ":active" not in sel:
            continue
        m = RE_SCALE_ROTATE.search(value)
        if m:
            state = ":hover" if ":hover" in sel else ":active"
            out.append(Finding(
                path, line_of(css, idx), "hover-scale",
                f"{state} 의 transform:{m.group(1)}(…) — {short(sel)}. "
                "손맛은 1px 들림(translateY)과 그림자로만. 확대·회전·눌림 축소 금지"))
    return out


def scan_infinite_motion(path: str, raw: str, is_html: bool) -> list[Finding]:
    css = css_of(raw, is_html)
    out: list[Finding] = []
    for prop, value, idx in iter_declarations(css):
        if prop not in ("animation", "animation-name"):
            continue
        low = value.lower()
        if "infinite" not in low and prop == "animation":
            continue
        if prop == "animation-name" and "infinite" not in css[idx:idx + 400].lower():
            continue
        if any(k in low for k in INFINITE_OK):
            continue
        out.append(Finding(
            path, line_of(css, idx), "infinite-motion",
            f"{prop}:{short(value.strip())} — {short(enclosing_selector(css, idx))}. "
            "무한 반복은 tactile-sweep(원석 빛)·tactile-loader(진행) 둘뿐. pulse·spin·bounce·shimmer·glow 금지"))
    for start, end, name in keyframes_spans(css):
        m = RE_FULL_ROTATE.search(css[start:end])
        if m:
            out.append(Finding(
                path, line_of(css, start + m.start()), "infinite-motion",
                f"@keyframes {name} 안의 {m.group(0)} — 회전 로더 금지. 진행은 .x-loader(좌→우 바)"))
    return out


def scan_legacy(path: str, raw: str, is_html: bool) -> list[Finding]:
    text = strip_comments(raw)
    out: list[Finding] = []
    css = css_regions(text, is_html) if is_html else text
    for m in RE_LEGACY_DECL.finditer(css):
        out.append(Finding(path, line_of(css, m.start()), "legacy-token",
                           f"{m.group(1)} 선언 — v3/v2 이름은 선언도 별칭도 없다"))
    if is_html:
        for m in RE_LEGACY_WORD.finditer(raw):
            line = line_of(raw, m.start())
            start = raw.rfind("\n", 0, m.start()) + 1
            end = raw.find("\n", m.start())
            line_txt = raw[start:end if end >= 0 else len(raw)]
            if RE_LEGACY_ONE_LINE.search(line_txt):
                continue
            out.append(Finding(path, line, "legacy-name", "공개 HTML 에 Weave"))
    for m in RE_FONT_LINK.finditer(raw):
        out.append(Finding(path, line_of(raw, m.start()), "legacy-font",
                           f"{m.group(0)} — Pretendard 외 웹폰트 금지"))
    return out


def scan_motion(path: str, raw: str, is_html: bool) -> list[Finding]:
    css = css_of(raw, is_html)
    out: list[Finding] = []
    for m in RE_STAR_NONE.finditer(css):
        out.append(Finding(path, line_of(css, m.start()), "reduced-motion",
                           "*{transition/animation:none} 은 포커스·색까지 죽인다. 모션 클래스에만."))
    for prop, value, idx in iter_declarations(css):
        if prop in ("transition", "animation", "transition-property", "animation-name") and re.search(r"\btop\b", value, re.I):
            out.append(Finding(path, line_of(css, idx), "anim-prop",
                               "transition/animation 에 top — 스캔은 transform:translateY"))
    return out


def scan_text_floor(path: str, raw: str, is_html: bool, allow: list[str]) -> list[Finding]:
    css = css_of(raw, is_html)
    out: list[Finding] = []
    for prop, value, idx in iter_declarations(css):
        if prop not in ("font-size", "font"):
            continue
        px = first_px(resolve(value, LIGHT))
        if px is None or px >= TEXT_FLOOR_PX:
            continue
        sel = enclosing_selector(css, idx)
        if any(a in sel for a in allow):
            continue
        if px >= LABEL_FLOOR_PX and any(h in sel for h in LABEL_HINTS):
            continue
        out.append(Finding(
            path, line_of(css, idx), "text-floor",
            f"{prop}:{value.strip()} = {px:g}px — {short(sel)}. "
            "바닥은 13px(--fs-caption). 11px(--fs-label) 은 태그·라벨·아이브로우 계열만"))
    return out


def scan_component_layer(path: str, raw: str, exempt: bool) -> list[Finding]:
    if exempt or RE_LINK_LIGHT.search(raw):
        return []
    linked = RE_LINK_TOKENS.search(raw)
    inlined = RE_INLINE_TOKEN_ROOT.search(strip_comments(raw))
    if not (linked or inlined):
        return []
    how = "tokens.css 를 링크" if linked else ":root 에 --canvas 를 인라인"
    return [Finding(
        path, line_of(raw, (linked or inlined).start()), "component-layer",
        f"{how}했는데 light.css 가 없다 — 값만 받고 재질 층을 다시 만들고 있다.")]


def scan_undefined_var(path: str, raw: str, is_html: bool,
                       known: set[str], runtime: set[str]) -> list[Finding]:
    css = css_of(raw, is_html)
    out: list[Finding] = []
    seen: set[str] = set()
    for m in RE_VAR.finditer(css):
        name = m.group(1)
        if name in known or name in runtime or name in seen:
            continue
        if "," in m.group(0):
            continue
        seen.add(name)
        hint = " — v3 어휘다(tools/x-to-v4.json 매핑)" if name.startswith("--x-") else ""
        out.append(Finding(path, line_of(css, m.start()), "undefined-var",
                           f"var({name}) — 어디에도 선언이 없다{hint}"))
    return out


def uses_canonical_system(decls: list[tuple[str, str, int, bool]]) -> bool:
    names = {n for n, _, _, _ in decls}
    return all(a in names for a in ANCHORS_REQUIRED)


def scan_parity(path: str, raw: str, is_html: bool, ignore: set[str],
                mode: str = "auto") -> tuple[list[Finding], bool]:
    css = css_of(raw, is_html)
    decls = collect_declarations(css)
    if mode != "always" and not uses_canonical_system(decls):
        return [], False
    own_light = {n: v for n, v, _, d in decls if not d}
    own_dark = {n: v for n, v, _, d in decls if d}
    tbl_light = {**LIGHT, **own_light}
    tbl_dark = {**DARK, **own_light, **own_dark}
    found: list[Finding] = []
    for name, value, line, dark in decls:
        if name in ignore:
            continue
        expected_tbl = DARK if dark else LIGHT
        if name not in expected_tbl:
            continue
        own_tbl = tbl_dark if dark else tbl_light
        got = normalize(resolve(value, own_tbl))
        want = normalize(resolve(expected_tbl[name], expected_tbl))
        if got != want:
            scope = "dark" if dark else "light"
            found.append(Finding(
                path, line, "parity",
                f'{name} ({scope}) = "{value}" ≠ 정본 "{expected_tbl[name]}"'))
    return found, True


def _dark_block_set(css: str, opener: re.Pattern[str]) -> tuple[dict[str, str], int] | None:
    m = opener.search(css)
    if not m:
        return None
    body, _ = block_body(css, m.end() - 1)
    return ({n: normalize(v) for n, v in RE_DECL.findall(body)}, line_of(css, m.start()))


def scan_dark_parity(path: str, raw: str, is_html: bool) -> list[Finding]:
    """tokens.css 의 두 다크 블록(@media prefers-color-scheme · [data-theme=dark])이 같은 집합인가."""
    if os.path.basename(path).lower() != "tokens.css":
        return []
    css = css_of(raw, is_html)
    media = _dark_block_set(css, RE_DARK_MEDIA_OPEN)
    attr = _dark_block_set(css, RE_DARK_ATTR_OPEN)
    if media is None and attr is None:
        return []
    if media is None:
        return [Finding(path, attr[1], "dark-parity",
                        "[data-theme=\"dark\"] 블록만 있고 @media (prefers-color-scheme: dark) 가 없다 — OS 다크에서 값이 갈린다")]
    if attr is None:
        return [Finding(path, media[1], "dark-parity",
                        "@media (prefers-color-scheme: dark) 블록만 있고 :root[data-theme=\"dark\"] 가 없다 — 수동 토글에서 값이 갈린다")]
    mv, ml = media
    av, al = attr
    out: list[Finding] = []
    for name in sorted(set(mv) - set(av)):
        out.append(Finding(path, ml, "dark-parity", f"{name} 은 @media 다크에만 있고 [data-theme=\"dark\"] 에 없다"))
    for name in sorted(set(av) - set(mv)):
        out.append(Finding(path, al, "dark-parity", f"{name} 은 [data-theme=\"dark\"] 에만 있고 @media 다크에 없다"))
    for name in sorted(set(mv) & set(av)):
        if mv[name] != av[name]:
            out.append(Finding(path, al, "dark-parity",
                               f"{name}: @media 다크 \"{mv[name]}\" ≠ [data-theme=\"dark\"] \"{av[name]}\""))
    return out


# ─────────────────────────────────────────────────────────────────────────────
# 대비 — 계약 자체를 검사한다(파일과 무관)
# ─────────────────────────────────────────────────────────────────────────────
def relative_luminance(hex_color: str) -> float:
    h = hex_color.strip().lstrip("#")
    if len(h) == 3:
        h = "".join(c * 2 for c in h)
    r, g, b = int(h[0:2], 16) / 255, int(h[2:4], 16) / 255, int(h[4:6], 16) / 255

    def f(c: float) -> float:
        return c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4

    return 0.2126 * f(r) + 0.7152 * f(g) + 0.0722 * f(b)


def contrast_ratio(a: str, b: str) -> float:
    l1, l2 = relative_luminance(a), relative_luminance(b)
    hi, lo = (l1, l2) if l1 >= l2 else (l2, l1)
    return (hi + 0.05) / (lo + 0.05)


CONTRAST_PAIRS = [
    ("--ink", "#0C1114", "--canvas", "#F5F5F5", 4.5, "라이트 본문"),
    ("--ink-2", "#5E6A6E", "--canvas", "#F5F5F5", 4.5, "라이트 보조 텍스트"),
    ("--aqua-deep", "#2E6774", "--canvas", "#F5F5F5", 4.5, "라이트 글자 아쿠아 / 캔버스"),
    ("--aqua-deep", "#2E6774", "--ground-hi", "#FFFFFF", 4.5, "라이트 글자 아쿠아 / 흰 면"),
    ("--aqua-ink", "#1B4650", "--aqua-hi", "#92CCDC", 4.5, "원석 글자 / 밝은 아쿠아"),
    ("--aqua-ink", "#1B4650", "--aqua", "#6EB4C4", 3.0, "원석 글자 / 아쿠아"),
    ("--ink(다크)", "#F2F5F5", "--canvas(다크)", "#0B0F11", 4.5, "다크 본문"),
    ("--ink-2(다크)", "#98A4A7", "--canvas(다크)", "#0B0F11", 4.5, "다크 보조 텍스트"),
    ("--aqua-deep(다크)", "#92CCDC", "--canvas(다크)", "#0B0F11", 4.5, "다크 글자 아쿠아"),
    ("--aqua-ink(다크)", "#10303A", "--aqua-hi(다크)", "#A6D8E5", 4.5, "다크 원석 글자"),
]

# 실패시키지 않고 기록만 남기는 쌍(보고서용 고정값)
CONTRAST_RECORD = [
    ("--aqua-ink on --aqua", "#1B4650", "#6EB4C4", 4.41, "원석 버튼 글자"),
    ("--aqua-ink on --aqua-mid", "#1B4650", "#59A1B0", 3.51, "원석 그라디언트 끝 — 15px 600 이상에서만"),
    ("--ink-3 on --canvas", "#9AA5A8", "#F5F5F5", 2.31, "비활성·플레이스홀더 전용 — 읽는 글자 금지"),
    ("--aqua outline on --canvas", "#6EB4C4", "#F5F5F5", 2.14, "포커스 링 — 비텍스트 3:1 미달, 2px+오프셋 3px 로 보완"),
]


def scan_contrast_contract() -> list[Finding]:
    out: list[Finding] = []
    for fg_n, fg, bg_n, bg, need, why in CONTRAST_PAIRS:
        got = contrast_ratio(fg, bg)
        if got + 1e-6 < need:
            out.append(Finding("tokens.css", 0, "contrast",
                               f"{fg_n} {fg} / {bg_n} {bg} = {got:.2f} < {need} ({why})"))
    return out


def contrast_records() -> list[str]:
    out = []
    for label, fg, bg, doc, why in CONTRAST_RECORD:
        got = contrast_ratio(fg, bg)
        drift = "" if abs(got - doc) < 0.005 else f" (기록값 {doc} 과 다르다 — 팔레트가 바뀌었다)"
        out.append(f"  계약 기록  {label} = {got:.2f}{drift} · {why}")
    return out


# ─────────────────────────────────────────────────────────────────────────────
# 설정 · 파일 수집
# ─────────────────────────────────────────────────────────────────────────────
DEFAULT_CONFIG = {
    "expect_version": EXPECT_VERSION,
    "include": ["**/*.html", "**/*.css"],
    "exclude": [".git/**", "node_modules/**"],
    "vendored": [],
    "mirrors": [],
    "ignore_vars": [],
    "parity_mode": "auto",
    "text_floor": "enforce",
    "text_floor_allow": [],
    "light_source_allow": [],
    "aqua_fill_allow": [],
    "tint_fill_allow": [],
    "raw_color_allow": [],
    "ink3_allow": [],
    "component_layer_exempt": [],
    "runtime_vars": [],
}


def load_config(path: str) -> dict:
    cfg = dict(DEFAULT_CONFIG)
    if os.path.exists(path):
        with open(path, encoding="utf-8") as fh:
            cfg.update({k: v for k, v in json.load(fh).items() if not k.startswith("$")})
    return cfg


def glob_to_re(pattern: str) -> re.Pattern[str]:
    out, i = [], 0
    while i < len(pattern):
        if pattern.startswith("**/", i):
            out.append(r"(?:[^/]+/)*")
            i += 3
        elif pattern.startswith("**", i):
            out.append(r".*")
            i += 2
        elif pattern[i] == "*":
            out.append(r"[^/]*")
            i += 1
        elif pattern[i] == "?":
            out.append(r"[^/]")
            i += 1
        else:
            out.append(re.escape(pattern[i]))
            i += 1
    return re.compile("^" + "".join(out) + "$")


_GLOB_CACHE: dict[str, re.Pattern[str]] = {}


def glob_match(rel: str, patterns: list[str]) -> bool:
    for p in patterns:
        rx = _GLOB_CACHE.get(p) or _GLOB_CACHE.setdefault(p, glob_to_re(p))
        if rx.match(rel):
            return True
    return False


def collect_files(root: str, cfg: dict) -> list[str]:
    out: list[str] = []
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [d for d in dirnames if d not in {".git", "node_modules", "__pycache__"}]
        for fn in filenames:
            rel = os.path.relpath(os.path.join(dirpath, fn), root).replace(os.sep, "/")
            if glob_match(rel, cfg["include"]) and not glob_match(rel, cfg["exclude"]):
                out.append(rel)
    return sorted(out)


def read(path: str) -> str:
    with open(path, encoding="utf-8", errors="replace") as fh:
        return fh.read()


def file_sha(path: str) -> str:
    h = hashlib.sha256()
    with open(path, "rb") as fh:
        h.update(fh.read())
    return h.hexdigest()


def build_known(texts, runtime: set[str]) -> set[str]:
    known = set(LIGHT) | set(DARK) | CONTRACT_ONLY_VARS | set(runtime)
    for raw in texts:
        known |= {n for n, _ in RE_DECL.findall(strip_comments(raw))}
    # v3 어휘는 known 에서 뺀다 — 사용은 undefined-var, 선언은 legacy-token 으로 잡는다
    return {n for n in known if not n.startswith("--x-")}


def scan_file(rel: str, raw: str, cfg: dict, known: set[str]) -> tuple[list[Finding], list[Finding], bool]:
    """(집행 대상, 텍스트 바닥, 파리티 적용됨)"""
    is_html = rel.lower().endswith((".html", ".htm"))
    par, applied = scan_parity(rel, raw, is_html, set(cfg.get("ignore_vars", [])), cfg.get("parity_mode", "auto"))
    f = list(par)
    f += scan_dark_parity(rel, raw, is_html)
    f += scan_light_source(rel, raw, is_html, list(cfg.get("light_source_allow", [])))
    f += scan_neumorphic(rel, raw, is_html)
    f += scan_aqua(rel, raw, is_html,
                   list(cfg.get("aqua_fill_allow", [])) + list(cfg.get("tint_fill_allow", [])))
    f += scan_ink3(rel, raw, is_html, list(cfg.get("ink3_allow", [])))
    f += scan_raw_color(rel, raw, is_html, list(cfg.get("raw_color_allow", [])))
    f += scan_font(rel, raw, is_html)
    f += scan_radius(rel, raw, is_html)
    f += scan_hover_scale(rel, raw, is_html)
    f += scan_infinite_motion(rel, raw, is_html)
    f += scan_legacy(rel, raw, is_html)
    f += scan_motion(rel, raw, is_html)
    f += scan_undefined_var(rel, raw, is_html, known, set(cfg.get("runtime_vars", [])))
    if is_html:
        f += scan_component_layer(rel, raw, glob_match(rel, list(cfg.get("component_layer_exempt", []))))
    floor = scan_text_floor(rel, raw, is_html, list(cfg.get("text_floor_allow", [])))
    return f, floor, applied


def run(root: str, cfg: dict, verbose: bool = False) -> list[Finding]:
    findings: list[Finding] = []
    files = collect_files(root, cfg)
    texts = {rel: read(os.path.join(root, rel)) for rel in files}
    known = build_known(texts.values(), set(cfg.get("runtime_vars", [])))
    floor_mode = cfg.get("text_floor", "enforce")
    floor_reported: list[Finding] = []

    findings += scan_contrast_contract()
    if str(cfg.get("expect_version")) != EXPECT_VERSION:
        findings.append(Finding("tactile_gate.json", 0, "config",
                                f'expect_version "{cfg.get("expect_version")}" ≠ 게이트 {EXPECT_VERSION}'))
    if verbose:
        for line in contrast_records():
            print(line)

    own_scale = 0
    for rel in files:
        f, floor, applied = scan_file(rel, texts[rel], cfg, known)
        own_scale += 0 if applied else 1
        if floor_mode == "enforce":
            f += floor
        else:
            floor_reported += floor
        findings += f
        if verbose and not f:
            print(f"  ok  {rel}{'' if applied else '  (자체 스케일)'}")

    for item in cfg.get("mirrors", []):
        rel = item["path"] if isinstance(item, dict) else item
        src_rel = (item.get("source") if isinstance(item, dict) else None) or "tokens.css"
        src = os.path.join(root, src_rel)
        dst = os.path.join(root, rel)
        if not os.path.exists(dst):
            findings.append(Finding(rel, 0, "mirror-missing", f"미러 {rel} 이 없다"))
            continue
        if os.path.exists(src) and file_sha(src) != file_sha(dst):
            findings.append(Finding(rel, 0, "mirror-drift",
                                    f"{rel} 이 {src_rel} 과 해시가 다르다 — 바이트 동일 복사"))
        elif verbose:
            print(f"  ok  {rel} (미러 {src_rel})")

    if not files and not cfg.get("mirrors"):
        findings.append(Finding(os.path.basename(root), 0, "config",
                                f"include 패턴 {cfg['include']} 에 걸린 파일이 0개다"))
    print(f"검사 파일 {len(files)}개(파리티 {len(files) - own_scale}개 · "
          f"자체 스케일 {own_scale}개) · 미러 {len(cfg.get('mirrors', []))}개")
    if floor_mode != "enforce":
        n_files = len({f.path for f in floor_reported})
        print(f"텍스트 바닥 미집행 — 위반 {len(floor_reported)}건 / {n_files}개 파일.")
    return findings


# ─────────────────────────────────────────────────────────────────────────────
# 셀프테스트
# ─────────────────────────────────────────────────────────────────────────────
ANCHOR = "--canvas:#F5F5F5;--ink:#0C1114;"
DARK_ANCHOR = "--canvas:#0B0F11;--ink:#F2F5F5;"
TOKENS_DARK_OK = (
    '@media (prefers-color-scheme: dark){:root:not([data-theme="light"]){' + DARK_ANCHOR + "}}"
    ':root[data-theme="dark"]{' + DARK_ANCHOR + "}"
)
TOKENS_DARK_BAD = (
    '@media (prefers-color-scheme: dark){:root:not([data-theme="light"]){--canvas:#0B0F11;}}'
    ':root[data-theme="dark"]{--canvas:#000000;}'
)

SELFTEST_BAD = [
    ("a.css", ".c{box-shadow:-6px -6px 14px var(--spec),7px 7px 16px var(--rule);}", "light-source"),
    ("b.css", ".c{box-shadow:var(--neu-raise);}", "light-source"),
    ("c.css", ".a{color:var(--aqua);}", "aqua-text"),
    ("d.css", ".p{color:#6EB4C4;}", "aqua-text"),
    ("e.css", ".card{background:var(--aqua);}", "aqua-fill"),
    ("f.html", "<p>Weave 카탈로그</p>", "legacy-name"),
    ("g.css", ":root{--point:#2E6774;}", "legacy-token"),
    ("h.css", ":root{--x-bg:#F5F5F5;}", "legacy-token"),
    ("i.html", '<link href="https://hangeul.pstatic.net/hangeul_static/css/maru-buri.css">', "legacy-font"),
    ("j.css", ".doc{font-family:Georgia,serif}", "font-literal"),
    ("j2.css", ".code{font-family:monospace}", "font-literal"),
    ("k.css", "*{transition:none!important}", "reduced-motion"),
    ("l.css", ".x-scan{transition:top 260ms linear;}", "anim-prop"),
    ("m.css", ".hero{color:#112233}", "raw-color"),
    ("m2.css", ".hero{background:rgba(0,0,0,.4)}", "raw-color"),
    ("n.css", ":root{--canvas:#F5F5F7;--ink:#0C1114;}", "parity"),
    ("o.css", ".n{font-size:11px;color:var(--ink)}", "text-floor"),
    ("o2.css", ".lbl{font-size:var(--fs-label)}", "text-floor"),
    ("p.css", ".h{font-weight:700}", "weight-cap"),
    ("p2.css", ".h{font:700 15px/1.4 var(--font)}", "weight-cap"),
    ("q.css", ".chip{border-radius:999px}", "pill-radius"),
    ("q2.css", ".chip{border-radius:50vh}", "pill-radius"),
    ("r.css", ".card:hover{transform:scale(1.03)}", "hover-scale"),
    ("r2.css", ".x-btn:active{transform:scale(.97)}", "hover-scale"),
    ("s.css", ".spin{animation:spin 1s linear infinite}", "infinite-motion"),
    ("s2.css", "@keyframes spin{to{transform:rotate(360deg)}}", "infinite-motion"),
    ("t.css", ".neu{box-shadow:6px 6px 12px var(--rule),3px 3px 6px var(--rule),1px 1px 2px var(--rule)}", "neumorphic"),
    ("u.css", ".hint{color:var(--ink-3)}", "ink3-text"),
    ("v.css", ".a{color:var(--x-ink)}", "undefined-var"),
    ("tokens.css", TOKENS_DARK_BAD, "dark-parity"),
]

SELFTEST_OK = [
    ("p01.css", ".glass{box-shadow:inset 1px 1px 0 var(--glass-edge),var(--glass-shadow);}"),
    ("p02.css", ".x-well{box-shadow:inset 1px 1px 0 var(--glass-edge),inset 0 0 0 1px var(--rule),0 10px 30px -18px rgba(12,17,20,.5)}"),
    ("p03.css", ".gem-ctl{color:var(--aqua-ink)}"),
    ("p04.css", ".x-lnk{color:var(--aqua-deep)}"),
    ("p05.css", ".gem-ctl{background:linear-gradient(135deg,var(--aqua-hi),var(--aqua) 55%,var(--aqua-mid))}"),
    ("p06.css", ".x-tgl.on{background:var(--aqua-mid)}"),
    ("p07.html", "<p>제르코닉스 디자인 시스템 / TACTILE</p>"),
    ("p08.css", ".x-scan{transition:transform var(--t-hover) linear,opacity var(--t-hover) var(--ease-out)}"),
    ("p09.css", ".tag{font-size:var(--fs-label)}"),
    ("p10.css", ".x-mono{font-family:var(--font);font-size:var(--fs-caption)}"),
    ("p11.css", ":root{" + ANCHOR + "--aqua-deep:#2E6774;}"),
    ("p12.css", ':root[data-theme="dark"]{' + DARK_ANCHOR + "--aqua-deep:#92CCDC;}"),
    ("p13.css", '@media (prefers-color-scheme: dark){:root:not([data-theme="light"]){' + DARK_ANCHOR + "--aqua-deep:#92CCDC;}}"),
    ("p14.css", ".gem-ctl:hover{transform:translateY(-1px)}"),
    ("p15.css", ".gem::after{animation:tactile-sweep 7s var(--ease-sweep) infinite}"),
    ("p16.css", ".x-loader::after{animation:tactile-loader 1.4s var(--ease-sweep) infinite}"),
    ("p17.css", ".x-tgl::after{border-radius:50%}"),
    ("p18.css", ".card{border-radius:var(--r-card)}"),
    ("p19.css", ".h{font-weight:600}"),
    ("p20.css", ".x-btn{font:600 var(--fs-small)/1.4 var(--font)}"),
    ("p21.css", "input::placeholder{color:var(--ink-3)}"),
    ("p22.css", '.x-btn[aria-disabled="true"]{color:var(--ink-3)}'),
    ("p23.css", ".tag.flag{color:var(--aqua-deep);border-color:color-mix(in srgb,var(--aqua) 50%,transparent);background:color-mix(in srgb,var(--aqua-tint) 45%,transparent)}"),
    ("p24.css", ".x-btn{border:1px solid color-mix(in srgb,var(--aqua-hi) 70%,white)}"),
    ("p25.css", ".x-btn:active{transform:none}"),
    ("p26.css", "@media(forced-colors:active){.x-btn{border:1px solid ButtonText}:focus-visible{outline-color:Highlight}.x-loader::after{background:Highlight}}"),
    ("p27.css", ".x-lnk::after{background:currentColor}"),
    ("p28.css", ".x-empty p{font-size:var(--fs-body)}"),
    ("p29.css", "@font-face{font-family:XK;src:url(xk.woff2) format(\"woff2\")}"),
    ("p30.css", ".gem-ctl{font:inherit;cursor:pointer}"),
    ("p31.css", ".x-loader::after{animation:tactile-loader 1.4s linear infinite}@keyframes tactile-loader{0%{transform:translateX(-100%)}100%{transform:translateX(360%)}}"),
    ("light.css", ".gem{border:1px solid #92CCDC;background:linear-gradient(160deg,#92CCDC,#6EB4C4)}"),
    ("tokens.css", TOKENS_DARK_OK),
]


def selftest() -> int:
    fails = 0
    floor_allow = ["th", "h4"]

    def scan_all(name: str, src: str) -> list[Finding]:
        is_html = name.endswith(".html")
        known = build_known([src], set())
        par, _ = scan_parity(name, src, is_html, set())
        return (par
                + scan_dark_parity(name, src, is_html)
                + scan_light_source(name, src, is_html)
                + scan_neumorphic(name, src, is_html)
                + scan_aqua(name, src, is_html)
                + scan_ink3(name, src, is_html)
                + scan_raw_color(name, src, is_html)
                + scan_font(name, src, is_html)
                + scan_radius(name, src, is_html)
                + scan_hover_scale(name, src, is_html)
                + scan_infinite_motion(name, src, is_html)
                + scan_legacy(name, src, is_html)
                + scan_motion(name, src, is_html)
                + scan_undefined_var(name, src, is_html, known, set())
                + scan_text_floor(name, src, is_html, floor_allow))

    for name, src, kind in SELFTEST_BAD:
        got = scan_all(name, src)
        if not any(f.kind == kind for f in got):
            print(f"selftest FAIL(미탐): {name} 에서 {kind} 를 잡지 못했다 — {got[0] if got else '탐지 0'}")
            fails += 1
    for name, src in SELFTEST_OK:
        got = scan_all(name, src)
        if got:
            print(f"selftest FAIL(오탐): {name} — {got[0]}")
            fails += 1

    # 다크 판정: 바깥 @media 프렐류드가 안쪽 :root:not([data-theme="light"]) 선언을 다크로 표시한다
    dark_css = '@media (prefers-color-scheme: dark){:root:not([data-theme="light"]){--canvas:#0B0F11;}}'
    if not any(d for _, _, _, d in collect_declarations(dark_css)):
        print("selftest FAIL(dark span): @media 프렐류드가 안쪽 선언을 다크로 표시하지 못한다")
        fails += 1
    light_css = ':root:not([data-theme="light"]){--canvas:#F5F5F5;}'
    if any(d for _, _, _, d in collect_declarations(light_css)):
        print("selftest FAIL(dark span): @media 밖 :root:not([data-theme=\"light\"]) 를 다크로 봤다")
        fails += 1

    for src, exempt, want in [
        ('<link rel="stylesheet" href="/tokens.css">', False, 1),
        ('<link rel="stylesheet" href="/tokens.css"><link rel="stylesheet" href="/light.css">', False, 0),
        ('<link rel="stylesheet" href="/tokens.css">', True, 0),
        ("<p>스타일 없는 페이지</p>", False, 0),
    ]:
        got = len(scan_component_layer("x.html", src, exempt))
        if got != want:
            print(f"selftest FAIL(component-layer): {src[:40]!r} exempt={exempt} → {got} ≠ {want}")
            fails += 1

    c = scan_contrast_contract()
    if c:
        print(f"selftest FAIL(contrast): {c[0]}")
        fails += 1

    glob_cases = [
        ("console/index.html", ["console/**/*.html"], True),
        ("index.html", ["**/*.html"], True),
        ("app/index.html", ["console/**/*.html"], False),
    ]
    for rel, pats, want in glob_cases:
        if glob_match(rel, pats) is not want:
            print(f"selftest FAIL(glob): {rel} vs {pats}")
            fails += 1

    # 정본 파일 자신 — 설정 없이(기본값 + text_floor_allow th·h4) 0건이어야 한다
    canon_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    canon = ("tokens.css", "light.css", "workspace.css", "master-doc.css")
    present = [(fn, read(os.path.join(canon_dir, fn)))
               for fn in canon if os.path.exists(os.path.join(canon_dir, fn))]
    known = build_known([src for _, src in present], set())
    for fn, src in present:
        got = scan_all(fn, src)
        got += scan_undefined_var(fn, src, False, known, set())
        seen = set()
        uniq = []
        for f in got:
            key = (f.kind, f.line, f.detail)
            if key in seen:
                continue
            seen.add(key)
            uniq.append(f)
        if uniq:
            print(f"selftest FAIL(이 리포 파일 이탈): {fn} — {uniq[0]}  (총 {len(uniq)}건)")
            fails += 1

    print("selftest OK" if not fails else f"selftest 실패 {fails}건")
    return 1 if fails else 0


def main() -> int:
    ap = argparse.ArgumentParser(description="TACTILE 파리티 게이트")
    ap.add_argument("--config", default=None)
    ap.add_argument("--root", default=None)
    ap.add_argument("--verbose", action="store_true")
    ap.add_argument("--selftest", action="store_true")
    args = ap.parse_args()

    if args.selftest:
        return selftest()

    here = os.path.dirname(os.path.abspath(__file__))
    cfg_path = args.config or os.path.join(here, "tactile_gate.json")
    root = args.root or os.path.dirname(here)
    cfg = load_config(cfg_path)

    print(f"TACTILE 게이트 · 기대 {cfg['expect_version']} · 루트 {os.path.basename(os.path.abspath(root))}")
    findings = run(root, cfg, args.verbose)
    if findings:
        print(f"\n실패 {len(findings)}건 — TACTILE 정본({EXPECT_VERSION}) 이탈:")
        for f in findings:
            print(f"  {f}")
        print("\n정본: tokens.css · 계약: TACTILE.md")
        return 1
    print("통과 — TACTILE 파리티 이상 없음")
    return 0


if __name__ == "__main__":
    sys.exit(main())
