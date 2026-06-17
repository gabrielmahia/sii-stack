# AI-KungFU Sovereign Institutional Infrastructure (SII) Stack

> *Build open, portable, local-first digital institutions that allow ordinary people and communities to access capabilities that historically required governments, corporations, or wealthy elites.*

[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)
[![Architecture](https://img.shields.io/badge/Architecture-4_Tier_Async-blue)](docs/architecture.md)
[![Models](https://img.shields.io/badge/Model_Routing-Tri_Polar-orange)](config/litellm.yaml)

---

## What This Is

A production-grade, sovereignty-first AI infrastructure stack for East Africa.
Built to survive: power outages, export controls, API rate limits, vendor failures, and metered mobile data.

**Not a chatbot. Not an app. A reusable coordination system.**

```
Input → Structure → Retrieve → Reason → Verify → Act → Record → Improve
```

---

## 4-Tier Architecture

```
┌─────────────────────────────────────────────────────────┐
│  TIER 1: Context & Memory (Git + SQLite + Markdown)     │
│  Sovereign, local-first, offline-readable               │
├─────────────────────────────────────────────────────────┤
│  TIER 2: Orchestration (n8n + Redis + Postgres)         │
│  Deterministic DAGs. Swarms for discovery only.         │
├─────────────────────────────────────────────────────────┤
│  TIER 3: Intelligence (LiteLLM — Tri-Polar Routing)     │
│  Western / Eastern / Sovereign. Switch via env var.     │
├─────────────────────────────────────────────────────────┤
│  TIER 4: Delivery (WhatsApp / HTMX / SMS / USSD)        │
│  Offline-first. <5KB payloads. No SPA.                  │
└─────────────────────────────────────────────────────────┘
```

---

## The Tri-Polar Model Router

No vendor lock-in. Switch entire model stack by changing one environment variable.

| Stack | Models | Use For | Cost |
|-------|--------|---------|------|
| Western | Claude Haiku, Gemini Flash | Complex reasoning, verification | ~$0.25/M |
| Eastern | DeepSeek, Qwen (SiliconFlow) | Bulk processing, Swahili | ~$0.14/M |
| Sovereign | Llama 3.2, Qwen 2.5 (Ollama) | Offline, sensitive data | Free |

**Rule:** < $1.00/M tokens for all production tasks. High-cost models ring-fenced for rare auditing.

---

## Quick Start

```bash
# 1. Clone and configure
git clone https://github.com/gabrielmahia/sii-stack
cd sii-stack
cp .env.example .env
# Fill in your API keys

# 2. Start sovereign stack only (offline-capable)
docker compose --profile offline up -d

# 3. Full stack
docker compose --profile full up -d

# 4. Install MCP tool layer
pip install mpesa-mcp wapimaji-mcp county-mcp kilimo-mcp afya-mcp \
            kra-mcp faida-mcp familia-mcp diaspora-mcp civic-agent-kit

# 5. Access n8n workflows
open http://localhost:5678

# 6. Access LiteLLM proxy
curl http://localhost:4000/health
```

---

## Domain Tool Layer (30 MCPs)

All MCP servers are pre-configured to run as tools within the LiteLLM + n8n stack.

| Layer | MCPs |
|-------|------|
| Economic | mpesa · mkopo · bima · soko · sifa · remit · kra · faida · familia · diaspora |
| Physical | wapimaji · nishati · usafiri · ardhi |
| Social | afya · afya-ya-akili · elimu · kazi · haki-ya-kazi · kilimo · jumuia · church · tafsiri |
| Civic | nyumba · habari · mazingira · county · historia |
| Foundation | civic-agent-kit · offline |

---

## Human-in-the-Loop Rules

Mandatory human review for:

- Legal advice · Medical advice · Land disputes
- Tax filing · Loan decisions · Immigration submissions

**AI prepares. Humans certify.**

---

## System Invariants

- **No multi-agent autonomy in production** — n8n DAGs are hardcoded, not self-organizing
- **< $1.00/M tokens** — bulk tasks use Eastern or Sovereign stack
- **Zero vendor lock-in** — switching model provider = changing one env var in `litellm.yaml`
- **72-hour offline test** — analyst with laptop must navigate full knowledge base with no internet

---


## Data Sovereignty Architecture

> This stack was designed for a specific constraint: communities must not be forced to choose between  
> access to AI assistance and control of their own data.

The tri-polar routing model is not just about cost. It is about independence:

| Tier | Who Controls It | Data Exposure |
|------|-----------------|---------------|
| Western (Claude/Gemini) | US corporations | Aggregated, never raw personal data |
| Eastern (DeepSeek/Qwen) | Chinese providers | Aggregated, never raw personal data |
| **Sovereign (Ollama local)** | **The community** | **Zero — data never leaves the device** |

**The 72-hour offline test** is the sovereignty test: if the internet goes down, the system must still
work. Community data processed locally never becomes a bargaining chip in aid negotiations.

**Human-in-the-loop is non-negotiable** for health, land, legal, and financial decisions.
AI prepares. Communities certify.

## MVP Build Plan

| Month | Focus |
|-------|-------|
| 1 | WhatsApp intake + Postgres + RAG + n8n + business permit workflow |
| 2 | Receipt/invoice extraction + vendor directory + escalation + Swahili |
| 3 | Dashboard + feedback loop + SME bookkeeping second workflow |

---

## Part of AI-KungFU East Africa Coordination Infrastructure

→ [30 MCP Servers](https://gabrielmahia.github.io/nairobi-stack)
→ [Portfolio](https://gabrielmahia.github.io)

## License

MIT © Gabriel Mahia | contact@aikungfu.dev
