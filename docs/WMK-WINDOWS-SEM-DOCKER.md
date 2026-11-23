# WMK Speakr Studio — Windows sem Docker

Este procedimento usa **Python 3.11 x64**, ambiente virtual, SQLite, Flask e Tailwind CSS, diretamente no Windows. **Não usa Docker, WSL nem XAMPP**.

## Requisitos

- Python 3.11 x64 (Python 3.13 pode ser incompatível com bibliotecas fixadas em requirements.txt)
- Git
- Node.js e npm (para gerar o CSS)
- FFmpeg e ffprobe no PATH para trabalhar com áudio
- Internet durante a primeira instalação das dependências
- Espaço livre para dependências, gravações e recursos de terceiros

## Instalar no PowerShell

Execute os comandos individualmente:

```powershell
cd D:\Ferramentas
git clone https://github.com/WalneyNF/WMK-Speakr-Studio.git
cd WMK-Speakr-Studio
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\wmk-instalar.ps1
```

Se já clonou o repositório, execute `git pull` **dentro** da pasta antes de rodar o instalador, em vez de clonar novamente.

O script:
1. Cria `.venv` para Python 3.11.
2. Instala as dependências de `requirements.txt`.
3. Baixa recursos web e compila `static/css/tailwind.css`.
4. Cria pastas locais `instance` e `uploads`.
5. Cria `.env` com caminhos locais, sem alterar um existente.
6. Inicializa SQLite.

## Criar administrador

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\wmk-criar-admin.ps1
```

Informe usuário, e-mail válido e senha (mínimo 8 caracteres).

## Iniciar

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\wmk-iniciar.ps1
```

Acesse **http://localhost:8899**. Para encerrar, pressione Ctrl+C no PowerShell.

## Teste básico, sem IA

1. Abra o login e verifique a identidade WMK.
2. Entre como administrador.
3. Teste navegação, temas, configurações e gravação.
4. Abra F12 para verificar eventuais erros 404.
5. Teste upload com áudio fictício. O upload pode funcionar mesmo sem transcrição.

## Transcrição e resumo

**ASR** converte voz em texto; **LLM** gera resumos/chat. São serviços separados.

Para Ollama, após `ollama list`, configure no `.env` (substitua o modelo pelo que realmente está instalado):

```ini
TEXT_MODEL_BASE_URL=http://127.0.0.1:11434/v1
TEXT_MODEL_API_KEY=ollama
TEXT_MODEL_NAME=llama3.2:1b
```

Para ASR, configure um conector compatível em `.env` e as respectivas credenciais. Não use chaves falsas para testar transcrição. Sem ASR, transcrição e resumos baseados nela não estarão operacionais.

## Diagnóstico

- Se `py -3.11` falhar, instale Python 3.11.
- Se `npx` falhar, instale Node.js LTS.
- Se `ffmpeg -version` falhar, instale FFmpeg e atualize PATH.
- Se ocorrer 404 de JS/CSS, execute novamente o instalador e examine `static/vendor` e `static/css/tailwind.css`.
- Em caso de falha, envie as **últimas 30 linhas do erro**, removendo senhas/tokens.

**Nota:** este é um caminho de desenvolvimento para Windows, não uma implantação de produção. Ainda precisa ser validado em uma máquina Windows real.

Licença original AGPL-3.0. Personalização: Walney Moreira Klein — walneyk@hotmail.com.
