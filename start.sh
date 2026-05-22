#!/bin/bash
echo "Starting Hermes Agent..."

hermes config set model.provider openrouter
hermes config set model.api_key "$OPENROUTER_API_KEY"
hermes config set model.base_url "https://openrouter.ai/api/v1"
hermes config set model.name "deepseek/deepseek-v4-flash:free"
hermes config set model.default "deepseek/deepseek-v4-flash:free"
hermes config set agent.model "deepseek/deepseek-v4-flash:free"

hermes config set gmail.email "$GMAIL_EMAIL"
hermes config set gmail.app_password "$GMAIL_APP_PASSWORD"

mkdir -p /root/.hermes
cat > /root/.hermes/.env << EOF
DISCORD_BOT_TOKEN=${DISCORD_BOT_TOKEN}
DISCORD_ALLOWED_USERS=${DISCORD_ALLOWED_USERS}
EOF

echo "All configured ✅"

# Start hermes in BACKGROUND
echo "Starting Discord gateway..."
hermes gateway run &

# Web server in FOREGROUND — Render detects port immediately
echo "Starting keep-alive server..."
python3 -c "
import http.server, os
port = int(os.environ.get('PORT', 10000))
class Handler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b'Hermes Agent is running!')
    def log_message(self, format, *args): pass
server = http.server.HTTPServer(('0.0.0.0', port), Handler)
print(f'Keep-alive server started on port {port}')
server.serve_forever()
"
