const format = require('pg-format');

module.exports = getTableNames;

/**
 * @param {any} arg
 * @param {Pool} arg.activePool - PG Pool to connect to db
 * @param {string} arg.schema - which schema to check table name
 */
async function getTableNames({ activePool, schema }) {
  let dbClient;

  // Validate Input
  if (!activePool) {
    throw new Error('An activePool is required');
  }
  if (!schema) {
    throw new Error('A schema must be provided in the function parameter object.')
  }

  // Fetch Tables
  try {
    dbClient = await activePool.connect();
    const sql = format(`
      SELECT table_name
      FROM information_schema.tables
      WHERE table_type='BASE TABLE'
      AND table_schema='%s'
    `, schema);
    tables = (await dbClient.query(sql)).rows;
  } catch (e) {
    throw e;
  } finally {
    if (dbClient) {
      dbClient.release();
    }
  }

  return tables.map(t => t.table_name);
}