// Core Node
const fs = require('fs');
const path = require('path');
// Dependencies
const { Pool } = require('pg');
require('dotenv-safe').config();

// My Modules
const createUser = require('./utils/create-user');
const rebuildDb = require('./utils/rebuild-db');

// DB Schema SQL Statement
// ============================================
const rebuildDBSchemaFilePath = path.join(
  path.dirname(__filename),
  '../setup/schema.sql'
);
const rebuildDBSchemaSql = fs.readFileSync(rebuildDBSchemaFilePath).toString();
// ============================================

const {
  DB_SUPER_USER,
  DB_SUPER_PWD,
  DB_HOST,
  DB_NAME,
  DB_PORT,
  PREDICTS_WRITE_USER,
  PREDICTS_WRITE_USER_PWD,
  PREDICTS_READ_USER,
  PREDICTS_READ_USER_PWD,
} = process.env;

(async function createDatabase() {
  let activePool;
  let errorEncountered = false;

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
    console.error('Error creating Pool');
    errorEncountered = true;
    throw e;
  }

  // Create Users
  try {
    // Create Read User
    await createUser({
      activePool,
      user: {
        username: PREDICTS_READ_USER,
        password: PREDICTS_READ_USER_PWD
      }
    });
    // Create Write User
    await createUser({
      activePool,
      user: {
        username: PREDICTS_WRITE_USER,
        password: PREDICTS_WRITE_USER_PWD
      }
    });
  } catch (e) {
    console.error('Error creating users');
    errorEncountered = true;
    throw e;
  }

  // Update Schema
  try {
    await rebuildDb({
      activePool,
      schemaSql: rebuildDBSchemaSql,
      superuser: DB_SUPER_USER,
      readUser: PREDICTS_READ_USER,
      writeUser: PREDICTS_WRITE_USER
    });
  } catch (e) {
    console.log(`Error Encountered rebuilding DB`);
    errorEncountered = true;
    throw e;
  }

  if (!errorEncountered) {
    console.log('Database and users created');
    process.exit(0);
  }
})().catch(e => {
  console.error(e.stack);
  process.exit(1);
});

process.on('uncaughtException', (err) => {
  console.error(err.stack);
  process.exit(1);
});
