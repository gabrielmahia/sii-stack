# AI-KungFU SII Stack — Makefile

.PHONY: up-offline up-full down logs install-mcps pull-models health

# Start sovereign (offline) stack only
up-offline:
	docker compose --profile offline up -d
	@echo "Sovereign stack running. Ollama at http://localhost:11434"

# Start full stack
up-full:
	docker compose --profile full up -d
	@echo "Full SII stack running."
	@echo "  n8n:     http://localhost:5678"
	@echo "  LiteLLM: http://localhost:4000"
	@echo "  Gateway: http://localhost:8000"

# Stop all services
down:
	docker compose down

# View logs
logs:
	docker compose logs -f

# Install all 30 MCP servers
install-mcps:
	pip install \
	  mpesa-mcp mkopo-mcp bima-mcp soko-mcp sifa-mcp remit-mcp kra-mcp faida-mcp \
	  familia-mcp diaspora-mcp wapimaji-mcp nishati-mcp usafiri-mcp ardhi-mcp \
	  afya-mcp afya-ya-akili-mcp elimu-mcp kazi-mcp haki-ya-kazi-mcp kilimo-mcp \
	  jumuia-mcp church-mcp tafsiri-mcp nyumba-mcp habari-mcp mazingira-mcp \
	  county-mcp historia-mcp civic-agent-kit offline-mcp
	@echo "30 MCP servers installed."

# Pull recommended sovereign models
pull-models:
	ollama pull llama3.2:3b
	ollama pull qwen2.5:3b
	@echo "Sovereign models ready for offline operation."

# Health check
health:
	curl -s http://localhost:4000/health | python3 -m json.tool
	curl -s http://localhost:11434/api/tags | python3 -m json.tool
