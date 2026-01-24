// PM2 Ecosystem Configuration
// This file configures how PM2 manages the Node.js application

module.exports = {
  apps: [
    {
      name: 'cpale-api',
      script: './backend/server.js',
      cwd: '/var/www/cpaleexplained',
      
      // Environment
      env: {
        NODE_ENV: 'production',
        PORT: 5000
      },
      
      // Process management
      instances: 1,
      exec_mode: 'fork',
      
      // Auto-restart configuration
      autorestart: true,
      watch: false,
      max_memory_restart: '500M',
      
      // Logging
      error_file: '/var/log/pm2/cpale-api-error.log',
      out_file: '/var/log/pm2/cpale-api-out.log',
      log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
      
      // Advanced features
      min_uptime: '10s',
      max_restarts: 10,
      restart_delay: 4000,
      
      // Graceful shutdown
      kill_timeout: 5000,
      listen_timeout: 3000,
      
      // Environment variables (loaded from .env file)
      env_file: '.env'
    }
  ]
};
