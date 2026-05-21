FROM python:3.11-slim
ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/root
ENV PATH="/root/.local/bin:$PATH"

RUN apt-get update && apt-get install -y \
    curl wget git nodejs npm ffmpeg \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash

COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

CMD ["/app/start.sh"]
