#!/bin/bash
echo "Starting Hermes Agent..."

hermes config set model.provider openrouter
hermes config set model.api_key "$OPENROUTER_API_KEY"
hermes config set model.base_url "https://openrouter.ai/api/v1"
hermes config set model.name "deepseek/deepseek-r1:free"
hermes config set model.default "deepseek/deepseek-r1:free"
hermes config set agent.model "deepseek/deepseek-r1:free"

hermes config set gmail.email "$GMAIL_EMAIL"
hermes config set gmail.app_password "$GMAIL_APP_PASSWORD"

mkdir -p /root/.hermes
cat > /root/.hermes/.env << EOF
DISCORD_BOT_TOKEN=${DISCORD_BOT_TOKEN}
DISCORD_ALLOWED_USERS=${DISCORD_ALLOWED_USERS}
EOF

echo "All configured ✅"
echo "Starting Discord gateway..."
hermes gateway run
