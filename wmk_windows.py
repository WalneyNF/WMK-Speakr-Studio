"""Inicializador Windows do WMK Speakr Studio.

Exemplos:
    python wmk_windows.py --check
    python wmk_windows.py --admin
    python wmk_windows.py
"""
from __future__ import annotations

import argparse
import getpass
import os
import shutil
import sys
import webbrowser
from pathlib import Path

APP_NAME = "WMK Speakr Studio"
PORT = 8899


def application_dir() -> Path:
    # No executavel, dados devem ficar fora do _MEIPASS, para sobreviver
    # a atualizacoes. A versao fonte usa a pasta do projeto.
    if getattr(sys, "frozen", False):
        return Path(sys.executable).resolve().parent
    return Path(__file__).resolve().parent


def initialize_environment() -> tuple[Path, Path]:
    root = application_dir()
    os.chdir(root)
    from dotenv import load_dotenv
    load_dotenv(root / ".env", override=False)
    data_dir = Path(os.environ.get("WMK_DATA_DIR", str(root / "dados"))).expanduser().resolve()
    db_dir = data_dir / "instance"
    uploads = data_dir / "uploads"
    db_dir.mkdir(parents=True, exist_ok=True)
    uploads.mkdir(parents=True, exist_ok=True)
    database_file = db_dir / "transcriptions.db"
    os.environ.setdefault("SQLALCHEMY_DATABASE_URI", "sqlite:///" + database_file.as_posix())
    os.environ.setdefault("UPLOAD_FOLDER", str(uploads))
    os.environ.setdefault("DEFAULT_UI_LANGUAGE", "pt-BR")
    os.environ.setdefault("DEFAULT_OUTPUT_LANGUAGE", "pt-BR")
    os.environ.setdefault("ENABLE_INQUIRE_MODE", "false")
    os.environ.setdefault("ALLOW_REGISTRATION", "false")
    return root, data_dir


def ensure_database(app, db):
    with app.app_context():
        db.create_all()


def create_admin(app, db, User, bcrypt):
    from email_validator import validate_email, EmailNotValidError
    with app.app_context():
        if db.session.query(User).filter_by(is_admin=True).first():
            print("Ja existe um administrador. Use o login existente.")
            return
        print("Criacao do primeiro administrador (somente no terminal local).")
        while True:
            username = input("Usuario (3-20 caracteres): ").strip()
            if 3 <= len(username) <= 20 and not db.session.query(User).filter_by(username=username).first():
                break
            print("Usuario invalido ou existente.")
        while True:
            raw_email = input("E-mail: ").strip()
            try:
                validate_email(raw_email, check_deliverability=False)
                email = User.normalize_email(raw_email)
                if not User.find_by_email(email):
                    break
                print("E-mail ja cadastrado.")
            except EmailNotValidError as ex:
                print(f"E-mail invalido: {ex}")
        while True:
            password = getpass.getpass("Senha (minimo 8 caracteres): ")
            confirm = getpass.getpass("Confirme a senha: ")
            if len(password) >= 8 and password == confirm:
                break
            print("Senha invalida ou confirmacao diferente.")
        user = User(
            username=username, email=email,
            password=bcrypt.generate_password_hash(password).decode("utf-8"),
            is_admin=True, email_verified=True,
        )
        from src.services.user_defaults import apply_new_user_defaults
        apply_new_user_defaults(user)
        db.session.add(user)
        db.session.commit()
        print("Administrador criado. A senha nao sera exibida.")


def main() -> int:
    parser = argparse.ArgumentParser(description=APP_NAME)
    parser.add_argument("--check", action="store_true", help="Validar arquivos e importar a aplicacao")
    parser.add_argument("--admin", action="store_true", help="Criar o primeiro administrador")
    parser.add_argument("--no-browser", action="store_true", help="Nao abrir o navegador")
    args = parser.parse_args()
    root, data_dir = initialize_environment()
    print(f"{APP_NAME} | pasta: {root}")
    print(f"Dados locais: {data_dir}")

    if getattr(sys, "frozen", False):
        assets_root = Path(sys._MEIPASS)
    else:
        assets_root = root
    required = [
        assets_root / "templates" / "index.html",
        assets_root / "static" / "css" / "tailwind.css",
        assets_root / "static" / "vendor" / "js" / "vue.global.js",
    ]
    missing = [str(item) for item in required if not item.exists()]
    if missing:
        print("ERRO: faltam arquivos web: " + ", ".join(missing), file=sys.stderr)
        return 2
    if not shutil.which("ffmpeg"):
        print("AVISO: FFmpeg nao encontrado no PATH. Conversao de audio pode falhar.")
    try:
        from src.app import app, db, User, bcrypt
        ensure_database(app, db)
    except Exception as exc:
        print(f"ERRO ao preparar o servidor: {exc}", file=sys.stderr)
        return 3
    if args.check:
        print("OK: arquivos web, importacao Flask e banco SQLite.")
        return 0
    if args.admin:
        create_admin(app, db, User, bcrypt)
        return 0
    from waitress import serve
    url = f"http://127.0.0.1:{PORT}"
    print(f"Servidor iniciado: {url}")
    if not args.no_browser:
        webbrowser.open(url)
    serve(app, host="127.0.0.1", port=PORT, threads=8)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
