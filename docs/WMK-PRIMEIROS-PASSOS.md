# WMK Speakr Studio — Primeiros passos

**Personalização:** Walney Moreira Klein — walneyk@hotmail.com

## O que o projeto faz

Grava e recebe áudio/vídeo, transcreve fala, identifica participantes com provedores compatíveis, gera resumos, pesquisa transcrições e exporta informação. Base: [Speakr](https://github.com/murtaza-nasir/speakr).

## Executar com Docker

1. Instale Docker Desktop e habilite o mecanismo Linux/WSL2.
2. Copie `config/docker-compose.example.yml` para `docker-compose.yml` e `config/env.transcription.example` para `.env`.
3. Configure no `.env` um serviço ASR (para fala -> texto) e um modelo LLM (para sumarizar). Ollama é um serviço de LLM, não substitui automaticamente o ASR.
4. Execute `docker compose up -d`.
5. Acesse `http://localhost:8899` e siga a configuração inicial.

**Atenção:** Docker/ASR podem consumir bastante RAM/VRAM. Para máquinas modestas, prefira serviço de transcrição remoto ou ASR leve e LLM local pequeno. Não exponha as portas publicamente sem autenticação e HTTPS.

## Primeira entrega WMK

- [x] Logo WMK em SVG escalável
- [x] README em português com atribuições
- [x] Nome e ícone personalizados na PWA
- [x] Identidade da marca nas telas HTML principais
- [ ] Verificar instalação em Windows 10
- [ ] Validar provedor ASR
- [ ] Testar Ollama local e Groq
- [ ] Tradução integral pt-BR
- [ ] Rodar suíte pytest e testes frontend

## Licença

**AGPL-3.0.** Manter o arquivo LICENSE e os avisos de direitos autorais da versão original. Modificações disponibilizadas em rede podem gerar obrigações de oferta do código aos usuários, conforme a licença.
