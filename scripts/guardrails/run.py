#!/usr/bin/env python3
import argparse
import io
import json
import os
import re
import sys
from contextlib import redirect_stdout

def _extract_python(command: str) -> str:
    m = re.search(r"python\s+-\s+<<'PY'\n(.*)\nPY\n", command, re.S)
    if not m:
        raise ValueError("unsupported guardrail command format")
    return m.group(1)

def _run_embedded_python(code: str, env: dict) -> tuple[int, str]:
    stdout = io.StringIO()
    old_env = os.environ.copy()
    os.environ.update(env)
    try:
        ns = {"__name__": "__main__"}
        with redirect_stdout(stdout):
            try:
                exec(compile(code, "<guardrail>", "exec"), ns, ns)
            except SystemExit as e:
                rc = int(e.code) if isinstance(e.code, int) else 1
                return rc, stdout.getvalue()
    finally:
        os.environ.clear()
        os.environ.update(old_env)
    return 0, stdout.getvalue()

def load_guardrails(path: str) -> list[dict]:
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)

def select_guardrails(all_gr: list[dict], *, topic: str, iac: str, level: str) -> list[dict]:
    # Keep the exercised surface area focused so the lab seeds a small number of actionable signals.
    allowlist = None
    if topic.lower() == "security" and iac.lower() == "terraform" and level.lower() == "senior":
        allowlist = {
            "gr-security-terraform-lpv",
            "gr-cost-tags-fullset-terraform",
            "gr-observability-terraform-telemetry",
        }

    out = []
    for gr in all_gr:
        if (gr.get("iac") or "").lower() != iac.lower():
            continue
        if allowlist is not None and gr.get("id") not in allowlist:
            continue
        # Scope is used by some guardrails to limit applicability
        scope = (gr.get("scope") or "").lower()
        if scope and (level.lower() not in scope or iac.lower() not in scope):
            continue
        out.append(gr)
    out.sort(key=lambda d: d.get("id", ""))
    return out

def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--cloud", default="azure")
    ap.add_argument("--topic", default="security")
    ap.add_argument("--iac", default="terraform")
    ap.add_argument("--level", default="senior")
    ap.add_argument("--root", default="senior/terraform", help="IaC root for checks that use IAC_ROOT")
    ap.add_argument("--guardrails", default="guardrails.json")
    args = ap.parse_args()

    all_gr = load_guardrails(args.guardrails)
    selected = select_guardrails(all_gr, topic=args.topic, iac=args.iac, level=args.level)

    if not selected:
        print("guardrail unmet: no applicable guardrails found")
        return 1

    overall_rc = 0
    for gr in selected:
        gid = gr.get("id", "unknown")
        try:
            code = _extract_python(gr["command"])
        except Exception as e:
            print(gr.get("fail_message","guardrail unmet"))
            print(f"issues: runner_error=1 id={gid} detail={e}")
            overall_rc = 1
            continue

        env = {"IAC_ROOT": args.root}
        rc, out = _run_embedded_python(code, env=env)
        out = out.strip()
        if out:
            print(f"[{gid}]")
            print(out)
        if rc != 0:
            overall_rc = 1

    return overall_rc

if __name__ == "__main__":
    raise SystemExit(main())
