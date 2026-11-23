# WMK Speakr Studio — Instalacao e compilacao Windows

**Personalizacao:** Walney Moreira Klein — walneyk@hotmail.com  
**Origem:** Speakr (murtaza-nasir) | **Licenca:** GNU AGPLv3

## Opcoes

| Opcao | Python | Node.js | Docker | Resultado |
| --- | --- | --- | --- | --- |
| ZIP compilado pelo GitHub Actions | dispensado | dispensado | dispensado | Pasta com EXE |
| Instalar-WMK.cmd a partir do codigo | 3.11 x64 | LTS | dispensado | Ambiente para desenvolver |

O ZIP compilado ainda **nao inclui FFmpeg**. Para conversao de audio, instale FFmpeg e ffprobe no PATH. Transcricao exige um servico ASR configurado; resumo exige modelo LLM.

## Compilar pelo GitHub Actions

1. Entre em https://github.com/WalneyNF/WMK-Speakr-Studio/actions
2. Escolha **WMK Windows - Compilar executavel e ZIP**.
3. Selecione **Run workflow**, branch master.
4. Se a execucao ficar verde, abra o resultado, area **Artifacts**.
5. Baixe **WMK-Speakr-Studio-Windows-x64** e extraia o pacote e a pasta interna.
6. Execute **Diagnostico.cmd**, depois **Criar-Admin.cmd**, e por ultimo **Iniciar-WMK.cmd**.
7. Abra http://127.0.0.1:8899.

O workflow publicado ainda precisa passar em execucao real. Um build verde valida importacao e inicializacao minima, nao todos os recursos.

## Instalar e trabalhar no codigo fonte

Requisitos: Python 3.11 x64, Git, Node.js LTS e FFmpeg.

Abra PowerShell e execute um comando por vez:

~~~powershell
cd D:\Ferramentas
git clone https://github.com/WalneyNF/WMK-Speakr-Studio.git
cd WMK-Speakr-Studio
.\Instalar-WMK.cmd
.\Criar-Admin-WMK.cmd
.\Iniciar-WMK.cmd
~~~

Se o clone ja existir, use git pull na pasta do projeto.

## Compilacao local em Windows

Depois de executar Instalar-WMK.cmd e preparar o ambiente, rode **Compilar-Windows-WMK.cmd** na pasta do projeto. O script usa PyInstaller, executa o diagnostico basico e cria:

- dist/WMK-Speakr-Studio/WMK-Speakr-Studio.exe
- dist/WMK-Speakr-Studio/Diagnostico.cmd
- dist/WMK-Speakr-Studio/Criar-Admin.cmd
- dist/WMK-Speakr-Studio/Iniciar-WMK.cmd
- dist/WMK-Speakr-Studio-Windows-x64.zip

Se a compilacao falhar, leia a mensagem do PowerShell. O instalador nao apaga gravacoes nem substitui uma configuracao .env privada.

## Dados e configuracoes

O inicializador nativo utiliza **dados/instance/transcriptions.db** e **dados/uploads/**. A variavel WMK_DATA_DIR escolhe outro local. Um arquivo .env na pasta raiz permite configurar modelos, chaves e caminho dos dados.

Faca backup de dados/ antes de substituir versoes. Nao compartilhe .env, gravacoes e arquivos pessoais em repositorios publicos.

### Exemplo Ollama (somente geracao de texto)

~~~ini
TEXT_MODEL_BASE_URL=http://127.0.0.1:11434/v1
TEXT_MODEL_API_KEY=ollama
TEXT_MODEL_NAME=llama3.2:1b
~~~

Selecione um modelo realmente presente em ollama list. O ASR e configurado separadamente.

## Diagnostico e limitacoes

- Diagnostico.cmd verifica recursos, Flask e SQLite.
- Se o FFmpeg nao existir, conversoes de midia poderao falhar.
- Se faltar JS/CSS, falhou a geracao de assets.
- Erros ModuleNotFoundError em executavel indicam dependencia a adicionar ao PyInstaller.
- A porta usada e 8899, restrita a localhost.
- O executavel nao e assinado: SmartScreen pode alertar. Nao desative antivirus.
- Nao foi feito teste end-to-end do ASR, upload, login e IA em Windows.
- Para instalador MSI/Inno Setup e releases assinadas, validar antes a distribuicao portatil.

## Licenciamento

Base original Speakr sob GNU AGPLv3, incluindo obrigacoes de disponibilizacao de codigo pertinentes. A personalizacao WMK nao remove creditos anteriores.
