FROM mcr.microsoft.com/devcontainers/javascript-node:1-22-bookworm

RUN npm install -g @google/gemini-cli@latest

RUN curl -LsSf https://astral.sh/uv/install.sh | sh \
    && cp /root/.local/bin/uv /usr/local/bin/uv \
    && cp /root/.local/bin/uvx /usr/local/bin/uvx
