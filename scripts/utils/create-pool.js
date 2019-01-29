// Dependencies
const { Pool } = require('pg');
require('dotenv-safe').config();

const {
  DB_SUPER_USER,
  DB_SUPER_PWD,
  DB_HOST,
  DB_NAME,
  DB_PORT
} = process.env;

module.exports = createPool;

async function createPool() {
  let activePool;

  // Create Pool
  try {
    activePool = new Pool({
      user: DB_SUPER_USER,
      password: DB_SUPER_PWD,
      host: DB_HOST,
      database: DB_NAME,
      port: DB_PORT
    });
  } catch (e) {
    throw e;
  }

  return activePool;
}
