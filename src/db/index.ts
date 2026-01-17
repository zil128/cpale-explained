import 'dotenv/config';
import { drizzle } from 'drizzle-orm/mysql2';
import mysql from 'mysql2/promise';
import * as schema from './schema';

// Create connection pool
const poolConnection = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  port: Number(process.env.DB_PORT) || 3306,
  user: process.env.DB_USER || 'cpale_user',
  password: process.env.DB_PASSWORD || 'cpale_password',
  database: process.env.DB_NAME || 'cpale_explained',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
});

// Create Drizzle instance with schema
export const db = drizzle(poolConnection, { schema, mode: 'default' });

// Export schema for convenience
export * from './schema';

// Export pool for direct access if needed
export { poolConnection };
