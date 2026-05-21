#!/bin/bash
echo "Starting Hermes Agent..."

hermes config set model.provider openrouter
hermes config set model.api_key "$OPENROUTER_API_KEY"
hermes config set model.base_url "https://openrouter.ai/api/v1"
hermes config set model.name "deepseek/deepseek-r1:free"
hermes config set model.default "deepseek/deepseek-r1:free"  # ← add this
hermes config set agent.model "deepseek/deepseek-r1:free"    # ← and this

hermes config set gmail.email "$GMAIL_EMAIL"
hermes config set gmail.app_password "$GMAIL_APP_PASSWORD"

# Write Telegram credentials
mkdir -p /root/.hermes
cat > /root/.hermes/.env << EOF
TELEGRAM_BOT_TOKEN=${TELEGRAM_BOT_TOKEN}
TELEGRAM_ALLOWED_USERS=${TELEGRAM_ALLOWED_USERS}
EOF

echo "All configured ✅"

# Keep-alive server for HF
python3 -c "
import http.server, threading
class Handler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b'Hermes Agent is running!')
    def log_message(self, format, *args): pass
server = http.server.HTTPServer(('0.0.0.0', 7860), Handler)
threading.Thread(target=server.serve_forever, daemon=True).start()
" &

echo "Starting Telegram gateway..."
hermes gateway run