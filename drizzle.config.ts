import 'dotenv/config';
import { defineConfig } from 'drizzle-kit';

export default defineConfig({
  out: './drizzle',
  schema: './drizzle/schema.ts',
  dialect: 'mysql',
  dbCredentials: {
    host: process.env.DB_HOST || 'localhost',
    port: Number(process.env.DB_PORT) || 3306,
    user: process.env.DB_USER || 'cpale_user',
    password: process.env.DB_PASSWORD || 'cpale_password',
    database: process.env.DB_NAME || 'cpale_explained',
  },
  verbose: true,
  strict: false,
});
