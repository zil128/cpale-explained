#!/bin/bash
# CPALE Explained - SSL Certificate Setup
# Obtains and configures Let's Encrypt SSL certificate

set -e

echo "=========================================="
echo "CPALE Explained - SSL Certificate Setup"
echo "=========================================="
echo ""

echo "Step 1: Testing DNS resolution..."
if ! nslookup cpaleexplained.com &> /dev/null; then
    echo "⚠️  DNS not resolved yet. Please wait for DNS propagation."
    echo "You can check with: nslookup cpaleexplained.com"
    exit 1
fi

echo "✅ DNS resolved"
echo ""

echo "Step 2: Obtaining SSL certificate..."
echo "You will be prompted for:"
echo "  - Email address (for renewal notifications)"
echo "  - Terms of Service agreement"
echo ""

certbot --nginx -d cpaleexplained.com -d www.cpaleexplained.com

echo ""
echo "Step 3: Testing auto-renewal..."
certbot renew --dry-run

echo ""
echo "=========================================="
echo "✅ SSL setup complete!"
echo "=========================================="
echo ""
echo "Your site is now accessible via HTTPS:"
echo "  https://cpaleexplained.com"
echo "  https://www.cpaleexplained.com"
echo ""
echo "Certificate auto-renewal is configured."
echo ""
