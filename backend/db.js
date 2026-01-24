/**
 * Database Connection Pool
 * Shared MySQL pool for all services and routes
 */

const mysql = require('mysql2/promise');
require('dotenv').config();

// Create the connection pool
const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 3306,
  user: process.env.DB_USER || 'cpale_user',
  password: process.env.DB_PASSWORD || 'cpale_password',
  database: process.env.DB_NAME || 'cpale_explained',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
  timezone: '+00:00', // Force UTC timezone for consistent date handling
  dateStrings: false  // Return dates as JavaScript Date objects
});

// Test the connection
pool.getConnection()
  .then(connection => {
    console.log('Database pool created successfully');
    connection.release();
  })
  .catch(err => {
    console.error('Error creating database pool:', err.message);
  });

module.exports = pool;
