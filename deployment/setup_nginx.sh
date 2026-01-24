#!/bin/bash
# CPALE Explained - Nginx Configuration Script
# Sets up Nginx as reverse proxy and static file server

set -e

echo "=========================================="
echo "CPALE Explained - Nginx Setup"
echo "=========================================="
echo ""

NGINX_CONF="/etc/nginx/sites-available/cpaleexplained"
APP_DIR="/var/www/cpaleexplained"

echo "Step 1: Creating Nginx configuration..."
cat > "$NGINX_CONF" <<'EOF'
server {
    listen 80;
    listen [::]:80;
    server_name cpaleexplained.com www.cpaleexplained.com;

    # Logging
    access_log /var/log/nginx/cpaleexplained_access.log;
    error_log /var/log/nginx/cpaleexplained_error.log;

    # Root directory
    root /var/www/cpaleexplained/landing-page;
    index index.html;

    # Max upload size (for payment proofs)
    client_max_body_size 10M;

    # API reverse proxy
    location /api/ {
        proxy_pass http://localhost:5000/api/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }

    # Uploads directory
    location /uploads/ {
        alias /var/www/cpaleexplained/uploads/;
        autoindex off;
    }

    # Static files
    location / {
        try_files $uri $uri/ =404;
    }

    # Cache static assets
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2|ttf|eot)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
    }

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
}
EOF

echo "✅ Nginx configuration created"
echo ""

echo "Step 2: Enabling site..."
rm -f /etc/nginx/sites-enabled/default
ln -sf "$NGINX_CONF" /etc/nginx/sites-enabled/cpaleexplained
echo "✅ Site enabled"
echo ""

echo "Step 3: Testing Nginx configuration..."
nginx -t
echo "✅ Nginx configuration valid"
echo ""

echo "Step 4: Reloading Nginx..."
systemctl reload nginx
systemctl status nginx --no-pager
echo "✅ Nginx reloaded"
echo ""

echo "=========================================="
echo "✅ Nginx setup complete!"
echo "=========================================="
echo ""
echo "Your site should now be accessible at:"
echo "  http://cpaleexplained.com"
echo "  http://www.cpaleexplained.com"
echo ""
echo "Next step: Wait for DNS propagation, then run setup_ssl.sh"
echo ""
