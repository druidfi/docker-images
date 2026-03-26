FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    jq \
    chromium \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash claude

USER claude
ENV HOME=/home/claude

RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/home/claude/.bun/bin:$PATH"

RUN bun i -g @anthropic-ai/claude-code pinchtab && \
    bun /home/claude/.bun/install/global/node_modules/pinchtab/scripts/postinstall.js && \
    mkdir -p ~/.pinchtab && \
    ([ -f ~/.pinchtab/config.json ] || echo '{}' > ~/.pinchtab/config.json) && \
    jq '.browser.extraFlags = "--ignore-certificate-errors"' \
    ~/.pinchtab/config.json > /tmp/pinchtab-config.json && \
    mv /tmp/pinchtab-config.json ~/.pinchtab/config.json

USER root
RUN ln -s /home/claude/.bun/bin/bun /usr/local/bin/node

COPY --chown=claude:claude entrypoint.sh /home/claude/entrypoint.sh
RUN chmod +x /home/claude/entrypoint.sh

USER claude
ENTRYPOINT ["/home/claude/entrypoint.sh"]
