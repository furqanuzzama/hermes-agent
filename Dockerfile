FROM python:3.11-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/root
ENV PATH="/root/.local/bin:$PATH"

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    nodejs \
    npm \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Hermes Agent
RUN curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash

# Copy startup script
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Expose port for keep-alive ping
EXPOSE 7860

CMD ["/app/start.sh"]