#!/usr/bin/env python3
"""Official copy of Noto Sans CJK KR VF + OFL + SOURCE.

Owner: xerkonix-flutter-library
Source: xerkonix-design-system/lib/fonts/noto_sans_cjk_kr/

Apps keep their own 10.4MB deploy copy (Docker/Railway cannot take a
runtime pub font). That duplication is the consume path, not a defect.
Hand copies without PROVENANCE.json are not a finished apply.

  python3 tools/sync_tactile_fonts.py --write --dest <consumer-font-dir>
  python3 tools/sync_tactile_fonts.py --write --consumer cotact --workspace <ws>
  python3 tools/sync_tactile_fonts.py --check --dest <consumer-font-dir>
  python3 tools/sync_tactile_fonts.py --selftest
"""
from __future__ import annotations

import argparse
import hashlib
import json
import shutil
import sys
import tempfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
LIB_ROOT = HERE.parent
MANIFEST_NAME = "tactile_font_mirrors.json"
PROVENANCE_NAME = "PROVENANCE.json"
KIND = "xerkonix-tactile-font-consumer"


def load_manifest() -> dict:
    return json.loads((HERE / MANIFEST_NAME).read_text(encoding="utf-8"))


def source_dir() -> Path:
    rel = load_manifest()["source"]
    return (LIB_ROOT / rel).resolve()


def listed_files() -> list[str]:
    return list(load_manifest()["files"])


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def provenance_payload(files: list[str], src: Path) -> dict:
    out = {
        "kind": KIND,
        "owner": "xerkonix-flutter-library",
        "source": load_manifest()["source"],
        "generator": "tools/sync_tactile_fonts.py",
        "not": "tools/tactile_gate.json",
        "files": {},
    }
    for name in files:
        path = src / name
        out["files"][name] = {
            "sha256": sha256_file(path),
            "bytes": path.stat().st_size,
        }
    return out


def copy_to(dest: Path) -> None:
    src = source_dir()
    files = listed_files()
    dest.mkdir(parents=True, exist_ok=True)
    for name in files:
        shutil.copy2(src / name, dest / name)
    (dest / PROVENANCE_NAME).write_text(
        json.dumps(provenance_payload(files, src), indent=2) + "\n",
        encoding="utf-8",
    )


def check_dest(dest: Path, require_source: bool = False) -> list[str]:
    errors: list[str] = []
    proven_path = dest / PROVENANCE_NAME
    if not proven_path.is_file():
        return [
            f"{dest}: PROVENANCE.json 없음 — 손복사 3벌은 공식 폰트 소비가 아니다. "
            "tools/sync_tactile_fonts.py --write 로 재생성하라."
        ]
    try:
        proven = json.loads(proven_path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        return [f"{proven_path}: JSON 파싱 실패: {exc}"]
    if proven.get("kind") != KIND:
        errors.append(f"{proven_path}: kind 가 {KIND} 가 아니다")
    if proven.get("generator") != "tools/sync_tactile_fonts.py":
        errors.append(f"{proven_path}: generator 가 공식 복사기가 아니다")
    listed = listed_files()
    recorded = proven.get("files") or {}
    if sorted(recorded) != sorted(listed):
        errors.append(
            f"{dest}: provenance 파일 목록이 manifest 와 다름 "
            f"recorded={sorted(recorded)} expected={listed}"
        )
    for name in listed:
        path = dest / name
        if not path.is_file():
            errors.append(f"{path}: 소비 사본 없음")
            continue
        actual = sha256_file(path)
        expected = (recorded.get(name) or {}).get("sha256")
        if expected and actual != expected:
            errors.append(f"{path}: sha256 drift (local≠PROVENANCE)")
    src = source_dir()
    if src.is_dir():
        for name in listed:
            left = src / name
            right = dest / name
            if left.is_file() and right.is_file() and left.read_bytes() != right.read_bytes():
                errors.append(f"{right}: owner 원본과 바이트가 다름")
    elif require_source:
        errors.append(f"{src}: owner 원본을 찾지 못함")
    return errors


def resolve_consumer_dests(workspace: Path, consumer: str) -> list[Path]:
    manifest = load_manifest()
    known = manifest["consumers"]
    if consumer not in known:
        raise SystemExit(
            f"unknown --consumer {consumer}; known: {', '.join(sorted(known))}"
        )
    return [workspace / consumer / rel for rel in known[consumer]]


def selftest() -> int:
    src = source_dir()
    files = listed_files()
    missing = [name for name in files if not (src / name).is_file()]
    if missing:
        print("selftest FAIL source missing", missing, file=sys.stderr)
        return 1
    with tempfile.TemporaryDirectory() as tmp:
        dest = Path(tmp) / "fonts"
        copy_to(dest)
        errs = check_dest(dest, require_source=True)
        if errs:
            print("selftest FAIL after write", errs, file=sys.stderr)
            return 1
        (dest / "OFL.txt").write_text("drifted\n", encoding="utf-8")
        drifted = check_dest(dest)
        if not drifted:
            print("selftest FAIL drift not detected", file=sys.stderr)
            return 1
        (dest / PROVENANCE_NAME).unlink()
        if not check_dest(dest):
            print("selftest FAIL missing provenance not detected", file=sys.stderr)
            return 1
    print("selftest OK")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    parser.add_argument("--selftest", action="store_true")
    parser.add_argument("--dest", type=Path)
    parser.add_argument("--consumer")
    parser.add_argument("--workspace", type=Path)
    args = parser.parse_args()
    if args.write and args.check:
        parser.error("choose --write or --check")
    if args.selftest:
        return selftest()
    dests: list[Path] = []
    if args.dest:
        dests.append(args.dest.resolve())
    if args.consumer:
        workspace = (args.workspace or LIB_ROOT.parent).resolve()
        dests.extend(resolve_consumer_dests(workspace, args.consumer))
    if args.write:
        if not dests:
            parser.error("--write requires --dest or --consumer")
        for dest in dests:
            copy_to(dest)
            print(f"wrote {dest}")
        return 0
    if args.check:
        if not dests:
            parser.error("--check requires --dest or --consumer")
        errors: list[str] = []
        for dest in dests:
            errors.extend(check_dest(dest))
        if errors:
            for item in errors:
                print(item, file=sys.stderr)
            return 1
        print(f"tactile font mirrors: {len(dests)} dests; differences: 0")
        return 0
    parser.error("choose --write, --check, or --selftest")
    return 2


if __name__ == "__main__":
    raise SystemExit(main())
