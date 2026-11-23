"""Instala as dependencias Python adequadas ao Windows.

Exclui Gunicorn (servidor Unix) e psycopg2 (SQLite e o banco padrao).
"""
from pathlib import Path
import subprocess
import sys

root = Path(__file__).resolve().parent.parent
lines = (root / "requirements.txt").read_text(encoding="utf-8").splitlines()
skip = ("gunicorn", "psycopg2-binary")
lines = [line for line in lines if not line.strip().lower().startswith(skip)]
target = root / ".cache" / "requirements-windows-generated.txt"
target.parent.mkdir(parents=True, exist_ok=True)
target.write_text("\n".join(lines) + "\n", encoding="utf-8")
subprocess.check_call([sys.executable, "-m", "pip", "install", "-r", str(target)])
subprocess.check_call([sys.executable, "-m", "pip", "install", "waitress>=3.0,<4"])
