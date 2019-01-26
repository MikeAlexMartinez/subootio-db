const format = require('format');

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
    return new Error('activePool is required');
  }
  if (!schema) {
    return new Error('A schema must be provided in the function parameter object.')
  }

  // Fetch Tables
  try {
    await activePool.connect();
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
    dbClient.release();
  }

  return tables;
}